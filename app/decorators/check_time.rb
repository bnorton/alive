class CheckTime < Decorator

  def call(response)
    check.value.to_f >= response.duration
  end
end
