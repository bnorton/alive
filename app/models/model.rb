class Model
  def self.inherited(base)
    base.send(:include, Mongoid::Document)
    base.send(:include, Mongoid::Timestamps::Updated::Short)

    base.class_attribute :mongo_fields; base.mongo_fields = {}
    base.class_attribute :mongo_field_type_by_name; base.mongo_field_type_by_name = { '_id' => BSON::ObjectId, 'id' => BSON::ObjectId, 'created_at' => Time, 'updated_at' => Time, 'u_at' => Time }
    base.class_attribute :allows; base.allows = []

    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)

    base.before_create :__generate_defaults
  end

  module ClassMethods
    def bulk_insert(docs)
      return unless docs.present?

      self.collection.insert(docs)
    end

    def attrs(attributes = {})
      attributes.each do |(k, v)|
        self.mongo_fields[k] ||= {}
        self.mongo_fields[k].merge!(v.clone)
      end

      (vals = attributes.delete(Array))   && Helpers.parse_and_add(self, vals, :type => Array, :default => -> { [] })
      (hash = attributes.delete(Hash))    && Helpers.parse_and_add(self, hash, :type => Hash, :default => -> { {} })
      (ints = attributes.delete(Integer)) && Helpers.parse_and_add(self, ints, :type => Integer, :default => 0)

      Helpers.enum_fields(self, attributes)
      Helpers.string_fields(self, attributes)

      attributes.each do |(type, fields)|
        Helpers.parse_and_add(self, fields, :type => type)
      end
    end

    def allow(*names)
      options = names.last.is_a?(Hash) ? names.pop : {}
      options.each_pair {|name, klass| self.mongo_field_type_by_name[name.to_s] = klass }

      self.allows |= (names + options.keys).map(&:to_sym)
    end

    def indexed(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      unique  = options.delete(:uniq)

      raise ArgumentError, 'extra options: ' + options.keys.join(', ') if options.any?
      options.merge!(:unique => true) if unique

      self.index(args.each_with_object({}) {|name, h| h[name] = 1 }, options)
    end

    def async # see mongoid.yml for full spec
      self.where({}).tap do |r|
        r.with(:write => { :w => 0 }) unless Rails.env.test?
      end
    end

    ##
    # belongs_to :user, :album
    #
    # field :u_id, :type => ObjectId, :as => :u_id
    # belongs_to :user, :foreign_key => :u_id
    #
    def belongs_to(*names)
      options = names.last.is_a?(Hash) ? names.pop : {}
      raise ArgumentError, 'invalid foreign key' if options.key?(:foreign_key)

      key_gen = ->(name,l) { :"#{name.to_s.split('_').map {|part| part[0..l] }.join}_id" }

      names.each do |name|
        key = key_gen.(name, 0)
        key = key_gen.(name, 1) if self.method_defined?(key)

        value = :"#{name}_id"

        Helpers.add_field(self, key, :type => BSON::ObjectId, :as => value)
        super name, options.merge(:foreign_key => key)
      end
    end

    ##
    # If the names are an array of symbols make a has_many out of each
    # If a name has options then just make the call to Mongoid#has_many
    #
    def has_many(*names)
      if names.last.is_a?(Hash)
        super
      else
        names.each {|name| super name }
      end
    end
  end

  module InstanceMethods
    def async
      self.tap do |r|
        r.with(:write => { :w => 0 }) unless Rails.env.test?
      end
    end

    UTC = Time.find_zone('UTC').freeze
    def created_at
      @created_at ||= ActiveSupport::TimeWithZone.new(self.id.generation_time, UTC)
    end

    def oid
      id
    end

    def as_json
      hash = {}
      hash[:id] = self.id.to_s
      hash[:created_at] = self.created_at
      hash[:updated_at] = self.updated_at

      self.class.allows.each do |name|
        hash[name] = send(name)
      end

      hash
    end

    def __generate_defaults
      self.send(:defaults_before_create) if self.respond_to?(:defaults_before_create, true)

      true
    end
  end

  module Helpers
    def self.add_field(base, name, options={})
      if base.instance_methods.include?(name.to_sym)
        raise ArgumentError, "The method `#{name}` was already defined"
      end

      base.mongo_field_type_by_name[name.to_s] = options[:type]
      base.mongo_field_type_by_name[options[:as].to_s] = options[:type] if options[:as].present?

      raise ArgumentError, ':type is a required option' unless options[:type].present?

      base.field name, options
    end

    def self.enum_fields(base, attributes)
      enums = attributes.delete(Enum)

      enums && enums.each do |(name, values)|
        name, values = name.to_s, values.map {|v| v.nil? ? v : v.to_s }

        storage = :"_#{name[0..1]}"
        storage = :"_#{name[0..2]}" if base.method_defined?(storage)

        base.send(:const_set, name.upcase, values.freeze)
        add_field base, storage, :type => Integer, :default => 0

        enum_methods(base, name, values, storage)
      end
    end

    def self.enum_methods(base, name, values, storage)
      base.mongo_field_type_by_name[name.to_s] = String

      base.send(:define_method, name, -> { values[self[storage]] unless self[storage].nil? })
      base.send(:define_method, "#{name}=", ->(incoming) {
        item = values.index(incoming)
        self[storage] = item if item
      })

      base.validates name, :inclusion => { :in => values }

      base.send(:define_method, "#{name}_changed?", -> { send("#{storage}_changed?") })
      base.send(:define_method, "#{name}_was", -> { values[send("#{storage}_was").to_i] })

      ##
      # When the value is nil then (for defense against a nil storage value)
      # query against an impossible case to get an empty relation
      #
      base.define_singleton_method("#{name}_of") do |incoming|
        (value = values.index(incoming)).nil? ?
          self.where(:_id => -1) : self.where(storage => value)
      end
      base.scope(:active, -> { base.status_of(Status::ACTIVE) }) if name == 'status'

      ##
      # When the value is nil then don't perform updates
      #
      base.define_singleton_method("update_all_#{name}") do |incoming, *args|
        options = args.pop || {}

        (value = values.index(incoming)).nil? ? nil :
          update_all(options.merge(storage => value))
      end
    end

    def self.string_fields(base, attributes)
      (strings = attributes.delete(String)) && strings.each_pair do |as, name|
        options = { :type => String, :as => as }

        add_field base, name, options
        base.send(:define_method, :"#{as}=", ->(other) { self[as] = other.try(:strip) }) # String normalize to strip / remove leading and trailing whitespace
      end
    end

    def self.parse_and_add(base, field, options)
      field.each_pair do |as, name|
        add_field base, name, options.merge(:as => as)
      end
    end
  end
end
