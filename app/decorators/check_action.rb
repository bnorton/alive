class CheckAction < Decorator
  def to_s
    "Click on #{check.value}"
  end

  def call(response)
    session = response.raw
    self.response = response
    self.success = true

    session.click_link_or_button(check.value)
  rescue Capybara::ElementNotFound
    self.success = false
  end
end
