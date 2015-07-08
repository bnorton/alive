ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'

require 'mongoid'
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'rspec/its'
require 'factories'
require 'capybara/rails'
require 'mock_redis'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f }

change_driver = ->(name) { Capybara.current_driver = Capybara.javascript_driver = name }

Rails.logger.level = Mongoid.logger.level = 4 unless /RubyMine/ === ENV['RUBYLIB']

silence_warnings { Redis = MockRedis }

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = :defined
  config.infer_base_class_for_anonymous_controllers = true
  config.run_all_when_everything_filtered = true
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods

  config.include TestHelper
  config.include RequestHelper, :type => :feature

  WebMock.disable_net_connect!(:allow_localhost => true)

  Dir[Rails.root.join('app/models/**/*.rb')].each {|f| require f }
  Mongoid.models.map(&:create_indexes)

  config.before(:each) { Sidekiq.redis {|r| r.flushall } }
  config.before(:each) { Mongoid.models.map(&:delete_all) }

  # use :firefox => true as metadata to feature tests to run the test in /Applications/Firefox
  config.before(:each, :firefox => true) { change_driver.(:selenium) }
  config.after(:each, :firefox => true)  { change_driver.(:poltergeist) }

end
