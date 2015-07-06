require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Alive
  class Application < Rails::Application
    config.middleware.use Rack::Deflater

    config.assets.enabled = true

    config.active_support.deprecation = :notify

    config.log_formatter = ::Logger::Formatter.new
  end
end
