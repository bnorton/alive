class Response
  attr_accessor :raw, :code, :headers, :raw_body, :body, :duration

  def self.from_api(raw=nil)
    instance = new
    instance.raw = raw
    instance.code = raw.try(:code).to_i
    instance.headers = raw.try(:headers) || {}
    instance.raw_body = raw.try(:body)
    instance.body = (JSON.parse(instance.raw_body) rescue instance.raw_body) || ''
    instance.duration = raw.try(:total_time).to_f * 1000
    instance
  end

  def self.from_browser(session=nil, duration: 0.0)
    instance = new
    instance.raw = session
    instance.code = session.try(:status_code)
    instance.headers = Typhoeus::Response::Header.new(session.try(:response_headers) || {})
    instance.raw_body = session.try(:html) || ''
    instance.body = (JSON.parse(instance.raw_body) rescue instance.raw_body) || ''
    instance.duration = duration.to_f * 1000
    instance
  end

  def to_hash
    {
      :code => code,
      :duration => duration,
      :headers => headers.to_json,
      :body => raw_body
    }
  end
end
