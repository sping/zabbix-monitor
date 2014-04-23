module Zabbix

  # The +Zabbix::Config+ object used for initializing zabbix-monitor
  #
  # @example
  #   Zabbix.configure do |config|
  #     config.config_file_path = '/etc/zabbix/zabbix_agentd.conf'
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
  class Config

    # @return [String] the zabbix agentd config file location
    attr_accessor :config_file_path
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

    def mode= value
      allowed_modes = [:push, :file, :stdout].freeze
      if allowed_modes.include?(value)
        Zabbix.logger.info "[Config] setting mode to '#{value}'"
        @mode = value
      else
        Zabbix.logger.error "[Config] failed setting mode to '#{value}'"
        raise "Unsupported mode: #{value}"
      end
    end

  end
end
