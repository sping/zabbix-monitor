require 'zabbix/config'
require 'zabbix/monitor'
require 'zabbix/reader'
require 'yell'

# Zabbix Monitor
module Zabbix

  class FileNotFoundError < StandardError; end

  class << self

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   require 'zabbix'
    #
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
        l.adapter self.config.log_adapter, :filename => self.config.log_file_path, :symlink => false
      end
    end
  end
end
