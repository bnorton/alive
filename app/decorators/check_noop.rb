class CheckNoop < Decorator
  def call(*)
    true
  end
end
