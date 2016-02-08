module Zabbix

  # The +Zabbix::Config+ object used for initializing zabbix-monitor
  #
  # @example
  #   Zabbix.configure do |config|
  #     config.config_file_path = '/etc/zabbix/zabbix_agentd.conf'
  #     config.log_file_path = '/var/log/monitor.log' #optional
  #     config.host_name = 'servername'
  #     config.mode = :push
  #     config.interval = '1m'
  #     config.rules = [
  #       {
  #         :command => 'Monitor.new.test',
  #         :zabbix_key => 'zabbix.test'
  #       }
  #     ]
  #   end
  #
  class Config

    # @return [String] the zabbix agentd config file location
    attr_accessor :config_file_path

    # @note
    #   (optional) Defaults to +./log/#{RACK_ENV}.log+
    # @return [String] The zabbix-monitor log file location (optional)
    attr_accessor :log_file_path

    # @overload log_adapter
    #   @return [Symbol] The zabbix-monitor log adapter
    # @overload log_adapter=(value)
    #   Sets the yell / zabbix-monitor log adapter
    #   See https://github.com/rudionrails/yell#usage for more information (optional)
    #
    #   Options:
    #     :stdout logs to STDOUT
    #     :stderr logs to STDERR
    #     :file logs to a file
    #     :datefile logs to a timestamped file
    #   @param value [Symbol] the log_adapter
    #   @return [Symbol] the new log_adapter
    attr_accessor :log_adapter

    # @return [String] the zabbix hostname
    attr_accessor :host_name

    # @return [Array<Symbol>] the set of rules to monitor
    attr_accessor :rules

    # @overload mode
    #   @return [Symbol] the mode zabbix-monitor uses to process the results of the rules
    # @overload mode=(value)
    #   Sets the mode type, so zabbix-monitor knows how to process the results of the rules
    #
    #   Options:
    #     :push uses the Zabbix agent to push the data to the Zabbix server
    #     :file writes the data to tmp/zabbix-stats.yml
    #     :stdout writes the data to the stdout
    #
    #   @param value [Symbol] the mode
    #   @return [Symbol] the new mode
    #   @raise [StandardError] when a unsupported mode is specified
    attr_accessor :mode

    # @return [String] the data collection interval in format [NUMBER[smhd]], e.g. '30s' (thirty seconds)
    attr_accessor :interval

    def mode= value
      allowed_modes = [:push, :file, :stdout].freeze
      if allowed_modes.include?(value)
        @mode = value
      else
        raise "Unsupported mode: #{value}"
      end
    end

    def log_file_path
      @log_file_path || nil
    end

    def log_adapter
      @log_adapter || :file
    end

    def interval
      @interval || '1m'
    end

  end
end
