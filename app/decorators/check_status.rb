class CheckStatus < Decorator
  def to_s
    "Status equals #{check.value}"
  end

  def call(response)
    self.response = response
    self.success = check.value == response.code.to_s
  end
end
