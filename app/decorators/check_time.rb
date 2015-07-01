class CheckTime < Decorator
  def to_s
    "Response time is less than #{check.value}ms"
  end

  def call(response)
    check.value.to_f >= response.duration
  end
end
