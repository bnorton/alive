class CheckBody < Decorator
  def to_s
    check.key? ? "JSON Object #{check.key} equals #{check.value}" : "HTML body contains #{check.value}"
  end

  def call(response)
    self.response = response

    return (self.success = response.raw.has_text?(/#{Regexp.escape(check.value)}/i)) if Capybara::Session === response.raw

    self.success = case body = response.body
    when String
      body[check.value.to_s].present?
    when Hash
      check.key.split('.').each do |part|
        next unless body

        body = body[part]
      end

      body.to_s == check.value
    else false
    end
  end
end
