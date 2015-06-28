class CheckHeader < Decorator
  def call(response)
    response.headers[check.key] == check.value
  end
end
