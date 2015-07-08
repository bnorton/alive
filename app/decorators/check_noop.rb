class CheckNoop < Decorator
  def to_s
    "Check nothing - noop"
  end

  def call(response, *)
    self.response = response
    self.success = true
  end
end
