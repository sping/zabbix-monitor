require 'zabbix/config'
require 'zabbix/monitor'
require 'zabbix/file_parser'
require 'yell'

# Zabbix Monitor
module Zabbix

  class << self

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   Zabbix.configure do |config|
    #     config.config_file_path = '/etc/zabbix/zabbix_agentd.conf'
    #     config.log_file_path = '/var/log/monitor.log' #optional
    #     config.host_name = 'servername'
    #     config.mode = :push
    #     config.rules = [
    #       {
    #         :command => 'Monitor.new.test',
    #         :zabbix_key => 'zabbix.test'
    #       }
    #     ]
    #   end
    #
    # @param [Hash] config variables
    def configure
      yield config
    end

    # @return [Zabbix::Config] creates a new or returns the existing the zabbix-monitor config
    def config
      @config ||= Config.new
    end

    # @return [Yell] creates a new or returns the +Yell+ logger instance
    def logger
      @logger ||= Yell.new do |l|
        l.adapter :datefile, :filename => self.config.log_file_path, :symlink => true
      end
    end
  end
end
