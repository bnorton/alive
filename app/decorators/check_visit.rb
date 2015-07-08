class CheckVisit < Decorator
  def to_s
    "Navigate to #{check.value}"
  end

  def call(response)
    session = response.raw
    session.visit(check.value)

    self.success = session.status_code == 200
    self.response = Response.from_browser(session)
  end
end
