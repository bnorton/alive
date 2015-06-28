class Decorator
  attr_reader :model, :options

  def initialize(item, options={})
    @model = item
    @options = options

    define_singleton_method item.class.name.underscore, -> { model }
  end
end
