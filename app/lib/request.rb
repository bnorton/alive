class Request
  def self.run(test)
    params_breed = %w(get head delete).include?(test.breed)
    data = JSON.parse(test.body) rescue {  }
    data_key = params_breed ? :params : :body

    headers = JSON.parse(test.headers) rescue { }
    headers['Content-Type'] = test.json ? 'application/json' : 'application/x-www-form-urlencoded' unless params_breed

    request = Typhoeus::Request.new(test.url,
      :method => test.breed.to_sym,
      :headers => headers,
      data_key => data
    )

    Response.new(request.run)
  end
end
