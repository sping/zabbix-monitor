module Zabbix

  # The +Zabbix::Reader+ object used to get values from the monitor file
  class Reader

    def initialize
      filename = 'tmp/zabbix-stats.yml'
      raise FileNotFoundError, 'Monitoring file not found' if !File.exists?(filename)
      @file = File.new(filename)
    end

    # Get a value from the Zabbix monitor file
    #
    # @param key [String] zabbix key
    #
    # @return [String] The monitoring value
    def get_value key
      @file.readlines.each do |line|
        match = line.scan(/^\s+#{key}: (.*)/)[0]
        return match unless match.nil?
      end
      nil
    end
  end
end