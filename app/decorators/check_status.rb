class CheckStatus < Decorator

  def call(response)
    check.value == response.code.to_s
  end
end
