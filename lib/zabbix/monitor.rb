require 'json'
require 'yaml'
require 'fileutils'

module Zabbix

  # Base class for processing and delivering the results to an endpoint
  class Monitor

    # Loops through all rules and process the result
    # @return [void]
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

    # @return [Zabbix::Config] the zabbix-monitor config
    def config
      Zabbix.config
    end

    # Process the result for a rule based on the mode specified in the config
    #
    # @param key [String] zabbix key
    # @param value [String] the result from the rule's command
    #
    # @return [void]
    def process_data key, value
      case config.mode
      when :push
        to_zabbix key, value
      when :file
        to_file key, value
      when :stdout
        to_stdout key, value
      end
    end

    # Use +zabbix_sender+ command to send each result to the Zabbix server
    #
    # @param key [String] zabbix key
    # @param value [String] the result from the rule's command
    #
    # @return [void]
    def to_zabbix key, value
      result = `zabbix_sender -c #{config.config_file_path} -s "#{config.host_name}" -k #{key} -o #{value}`
      case $?.to_i
      when 0 # SUCCESS
        puts 'GREAT'
      else
        puts 'BUMMER'
      end
    end

    # Writes the result to a file
    #
    # @param key [String] zabbix key
    # @param value [String] the result from the rule's command
    #
    # @return [void]
    def to_file key, value
      filename = 'tmp/zabbix-stats.yml'
      File.mkdir 'tmp' unless File.directory?('tmp')
      if File.exists? filename
        yml = YAML::load_file(filename)
      else
        yml = {'statistics' => {'created_at' => Time.now.to_i}}
      end
      yml['statistics'][key] = value
      File.open(filename, 'w') { |file| file.write yml.to_yaml }
    end

    # Prints the result of the monitored rule to stdout
    #
    # @param key [String] zabbix key
    # @param value [String] the result from the rule's command
    #
    # @return [void]
    def to_stdout key, value
      puts "#{key}: #{value}"
    end
  end
end
