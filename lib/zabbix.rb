require 'zabbix/config'
require 'zabbix/monitor'

module Zabbix

  class << self

    # Call this method to modify defaults in your initializers.
    #
    # example:
    #
    # Zabbix.configure do |config|
    #   config.config_file_path = '/etc/zabbix/zabbix_agentd.conf'
    #   config.host_name = 'servername'
    #   config.mode = :push
    #   config.rules = [
    #     {
    #       :command => 'Monitor.new.test',
    #       :zabbix_key => 'zabbix.test'
    #     }
    #   ]
    # end
    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end
  end
end