require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require 'addressable/uri'

Bundler.require(*Rails.groups)

module Alive
  class Application < Rails::Application
    config.middleware.use Rack::Deflater

    config.assets.enabled = true
  end
end
