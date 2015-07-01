class CheckNoop < Decorator
  def to_s
    "Check nothing - noop"
  end

  def call(*)
    true
  end
end
