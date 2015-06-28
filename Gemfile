source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '~> 4.2'
gem 'railties'
gem 'mongoid', :github => 'mongoid/mongoid'
gem 'mongo', :github => 'mongodb/mongo-ruby-driver'
gem 'puma'

gem 'sidekiq'
gem 'whenever'
gem 'typhoeus'

# gem 'slack-notifier'
# gem 'hookly', '~> 0.9'

# gem 'jquery-rails'
# gem 'bootstrap-sass'

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'timecop'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'mock_redis'
  gem 'webmock'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'factory_girl'
end
