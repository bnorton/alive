class Response
  attr_accessor :raw, :code, :headers, :body, :duration

  def initialize(raw_response=nil)
    @raw = raw_response
    @code = raw.try(:code).to_i
    @headers = raw.try(:headers) || {}
    @raw_body = @raw.try(:body)
    @body = (JSON.parse(@raw_body) rescue @raw_body) || ''
    @duration = raw.try(:total_time).to_f * 1000
  end

  def to_hash
    {
      :code => code,
      :duration => duration,
      :headers => headers.to_json,
      :body => @raw_body
    }
  end
end
