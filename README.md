# Zabbix Monitor

Zabbix monitoring for Ruby apps. Works with pushing and polling: push data to the agent server with zabbix_sender or collect data with the Zabbix agent.

## Installation

Requires the Zabbix agent to be installed.

Add this line to your application's Gemfile:

    gem 'zabbix-monitor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zabbix-monitor

To include the rake tasks in your application, add the following line to your Rakefile (before `App::Application.load_tasks`):

    require 'zabbix/tasks'

## Usage

### For Rails applications:

Place your Zabbix Monitoring configuration in an initializer:

    Zabbix.configure do |config|
      config.config_file_path = '/etc/zabbix/zabbix_agentd.conf'
      config.host_name = 'servername'
      config.mode = :push
      config.rules = [
        {
          :command => 'Monitor.new.test',
          :zabbix_key => 'zabbix.test'
        }
      ]
    end

Put the host name as configured in your Zabbix server config in `config.host_name`.

Set the `config.mode` to one of the following options:

- `:push` uses the Zabbix agent to push the data to the Zabbix server
- `:file` writes the data to tmp/zabbix/monitor
- `:stdout` writes the data to the stdout

Put your monitoring rules in `config.rules`. Each rule contains a Ruby command to be executed by the Zabbix Monitor and the key as configured on the Zabbix Server.

Start running your monitoring jobs with:

    $ rake zabbix:collect_data

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
