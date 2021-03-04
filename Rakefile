task default: %w[spec]

task :spec do
  ENV["APP_ENV"] ||= 'test'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
end
