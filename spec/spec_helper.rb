ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/its'
require 'factories'
require 'capybara/rails'
require 'mock_redis'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f }

Capybara.register_driver :poltergeist do |app|
  require 'capybara/poltergeist'

  # See: https://github.com/ariya/phantomjs/issues/12234
  Capybara::Poltergeist::Driver.new(app,
    :timeout => 10,
    :phantomjs_logger => StringIO.new(''), # silence JavaScript console.log
    :phantomjs_options => %w(--load-images=false --ignore-ssl-errors=true),
  )
end

(change_driver = ->(name) { Capybara.current_driver = Capybara.javascript_driver = name }).(:poltergeist)

unless /RubyMine/ === ENV['RUBYLIB']
  Rails.logger.level = 4
  Moped.logger.level = 4
end

silence_warnings { Redis = MockRedis }

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = :defined
  config.infer_base_class_for_anonymous_controllers = true
  config.run_all_when_everything_filtered = true
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include Mongoid::Matchers
  config.include Moped::Cleaner

  config.include TestHelper
  config.include RequestHelper, :type => :feature

  WebMock.disable_net_connect!(:allow_localhost => true)

  Dir[Rails.root.join('app/models/**/*.rb')].each {|f| require f }
  Mongoid.models.map(&:create_indexes)

  config.before(:each) { Sidekiq.redis {|r| r.flushall } }

  # use :firefox => true as metadata to feature tests to run the test in /Applications/Firefox
  config.before(:each, :firefox => true) { change_driver.(:selenium) }
  config.after(:each, :firefox => true)  { change_driver.(:poltergeist) }

end
