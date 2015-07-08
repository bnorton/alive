class CheckHeader < Decorator
  def to_s
    "Header #{check.key} equals #{check.value}"
  end

  def call(response)
    self.response = response
    self.success = response.headers[check.key] == check.value
  end
end
