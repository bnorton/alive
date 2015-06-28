namespace :jobs do
  namespace :tests do
    desc 'Seed any Tests that are meant to be run before now'
    task :seed => :environment do
      ids = Test.where(:at.lt => Time.now).pluck(:id).
        map {|id| [id] }

      Sidekiq::Client.push_bulk('class' => TestWorker, 'args' => ids) if ids.any?
    end
  end
end
