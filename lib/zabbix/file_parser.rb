require 'yaml'

module Zabbix

  class FileParser

    def initialize
      @file = YAML.load_file('tmp/zabbix-stats.yml')
    end

    def get_value key
      @file['statistics'][key]
    end
  end
end