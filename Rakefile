require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

YARD::Rake::YardocTask.new do |t|
  t.options += ["--title", "Zabbix monitor Documentation"]
end
