class CheckTime < Decorator
  def to_s
    "Response time is less than #{check.value}ms"
  end

  def call(response)
    self.response = response
    self.success = check.value.to_f >= response.duration
  end
end
