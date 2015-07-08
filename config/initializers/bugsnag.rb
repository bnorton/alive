Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_KEY']
end if ENV['BUGSNAG_KEY'].present? && Rails.env.production?
