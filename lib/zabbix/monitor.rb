require 'json'

module Zabbix

  class Monitor

    def collect_data
      config.rules.each do |rule|
        value = eval rule[:command]
        process_data rule[:zabbix_key], value
      end
    rescue Exception => e
      puts 'NO GOOD'
      puts e.message
    end

    private

    def config
      Zabbix.config
    end

    def process_data key, value
      case config.mode
      when :push
        to_zabbix key, value
      when :file
        to_file key, value
      when :stdout
        to_stdout key, value
      else
        to_stdout key, value
      end
    end

    # Use zabbix_sender command to send each result to the Zabbix server
    def to_zabbix key, value
      result = `zabbix_sender -c #{config.config_file_path} -s "#{config.host_name}" -k #{key} -o #{value}`
      case $?.to_i
      when 0 # SUCCESS
        puts 'GREAT'
      else
        puts 'BUMMER'
      end
    end

    def to_file key, value
      raise 'Write to file is not implemented yet'
    end

    def to_stdout key, value
      puts "#{key}: #{value}"
    end
  end
end