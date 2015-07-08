class Decorator
  attr_reader :model, :options
  attr_writer :success

  attr_accessor :response

  def initialize(item, options={})
    @model = item
    @options = options

    define_singleton_method item.class.name.underscore, -> { model }
  end

  def success?
    !!@success
  end
end
