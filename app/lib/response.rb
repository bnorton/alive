class Response
  attr_accessor :raw, :code, :headers, :body, :duration

  def initialize(raw_response=nil)
    @raw = raw_response
    @code = raw.try(:code).to_i
    @headers = raw.try(:headers) || {}
    @body = (JSON.parse(@raw.try(:body)) rescue @raw.try(:body)) || ''
    @duration = raw.try(:total_time).to_i
  end

end
