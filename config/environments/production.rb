Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.force_ssl = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=31536000'

  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass
  config.assets.compile = false
  config.assets.digest = true

  config.assets.version = '1.0'

  config.log_level = :info
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'smtp.sendgrid.com',
    :port => 587,
    :enable_starttls_auto => true,
    :authentication => :plain,
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => 'heroku.com',
  }
end
