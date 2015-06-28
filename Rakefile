require 'rake/task'

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :default => %w(spec)
