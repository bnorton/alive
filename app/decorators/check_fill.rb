class CheckFill < Decorator
  def to_s
    "Fill in #{check.key} with #{check.value}"
  end

  def call(response)
    self.response = response
    self.success = true

    response.raw.fill_in check.key, :with => check.value
  rescue Capybara::ElementNotFound
    self.success = false
  end
end
