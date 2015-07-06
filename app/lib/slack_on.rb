class SlackOn
  def self.ping(message, options={})
    return unless (url = ENV['SLACK_URL']).present?

    client = Slack::Notifier.new(url, :channel => ENV['SLACK_CHANNEL'])
    options.each_pair do |k,v|
      message += "\n - #{k.to_s.titleize}: #{v}"
    end

    client.ping(message)
  end

  def self.passed(user, test_run)
    common(user, test_run, :Passed)
  end

  def self.failed(user, test_run)
    check = test_run.failed_check

    common(user, test_run, :Failed, :which => check.decorator.new(check).to_s)
  end

  private

  def self.common(user, test_run, name, opts={})
    test = test_run.test

    options = {
      :what => "#{test.breed.upcase} #{test.url}",
      :response_code => "`#{test_run.code}`",
      :response_duration => "`#{test_run.duration.to_i}ms`",
    }.merge(opts)

    ping "#{test.name} - #{name}", options
  end

end
