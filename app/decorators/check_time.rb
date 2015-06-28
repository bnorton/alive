class CheckTime < Decorator

  def call(response)
    check.value.to_i >= response.duration
  end
end
