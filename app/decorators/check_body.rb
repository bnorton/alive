class CheckBody < Decorator
  def call(response)
    case body = response.body
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
