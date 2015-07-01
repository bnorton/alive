class CheckStatus < Decorator
  def to_s
    "Status equals #{check.value}"
  end

  def call(response)
    check.value == response.code.to_s
  end
end
