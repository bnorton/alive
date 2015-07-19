class WebHook
  def self.run(hook, test_run)
    data = test_run.as_json

    unless hook.include_response
      data.delete(:headers)
      data.delete(:body)
    end

    data[:test] = test_run.test.as_json.select{|k,v| [:id, :name, :url].include? k}
    if test_run.failed_check_id
      data[:success] = false
      data[:failed_check] = test_run.failed_check.as_json
    else
      data[:success] = true
      data[:failed_check] = nil
    end

    request = Typhoeus::Request.new(hook.url,
      :method => :post,
      :headers => {"Content-Type" => "application/json"},
      :body => Oj.dump(data, mode: :compat, time_format: :xmlschema)
    )

    Response.from_api(request.run)
  end


end