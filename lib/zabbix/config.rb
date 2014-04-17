module Zabbix

  class Config

    attr_accessor :config_file_path, :host_name, :rules, :mode

    # Set the mode to one of :push, :file or :stdout
    #
    # Options:
    #
    #   :push uses the Zabbix agent to push the data to the Zabbix server
    #   :file writes the data to tmp/zabbix/monitor
    #   :stdout writes the data to the stdout
    def mode= value
      allowed_modes = [:push, :file, :stdout].freeze
      if allowed_modes.include?(value)
        @mode = value
      else
        raise "Unsupported mode: #{value}"
      end
    end
  end
end