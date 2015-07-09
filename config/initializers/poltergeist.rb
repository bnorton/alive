require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
   # See: https://github.com/ariya/phantomjs/issues/12234

  Capybara::Poltergeist::Driver.new(app,
    :timeout => 10,
    :phantomjs_logger => File.open(File::NULL), # silence JavaScript console.log
    :phantomjs_options => Rails.env.test? ? %w(--load-images=false --ignore-ssl-errors=true) : [],
  )
end

Capybara.current_driver = Capybara.javascript_driver = :poltergeist
Capybara.run_server = false
