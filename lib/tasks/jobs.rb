require File.expand_path('../../../config/boot', __FILE__)
require File.expand_path('../../../config/environment', __FILE__)

require 'clockwork'
include Clockwork

every(1.minute, 'Queueing all runnable tests') do
  ids = Test.where(:at.lt => Time.now).pluck(:id).map {|id| [id] }

  if ids.any?
    Rails.logger.info "Queueing #{ids.count} tests"
    Sidekiq::Client.push_bulk('class' => TestWorker, 'args' => ids) if ids.any?
  end
end
