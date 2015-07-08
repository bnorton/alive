require 'capybara/session'

class Poltergeist
  attr_reader :session

  def initialize
    @session = Capybara::Session.new(:poltergeist)
  end
end
