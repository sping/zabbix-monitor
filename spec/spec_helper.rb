require 'pry'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec/'
end

require 'zabbix'

RSpec.configure do |config|
  # configure yell logger's ENV and remove the logs files afterwards
  ENV['YELL_ENV'] = 'test'

  config.before :each do
    log_path = File.expand_path("../log", File.dirname(__FILE__))
    Dir[log_path + "/test*.log" ].each { |f| File.delete f }
  end
end
