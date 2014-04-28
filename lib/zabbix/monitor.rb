require 'json'
require 'yaml'
require 'fileutils'
require 'rufus-scheduler'

module Zabbix

  # Base class for processing and delivering the results to an endpoint
  class Monitor

    # Schedule the data collector
    # @return [void]
    def schedule
      Rufus::Scheduler.new.tap do |scheduler|
        scheduler.every '1m' do
          ActiveRecord::Base.connection_pool.with_connection do
            collect_data
          end
        end
      end.join
    end

    # Loops through all rules and process the result
    # @return [void]
    def collect_data
      current_zabbix_rule = nil
      config.rules.each do |rule|
        current_zabbix_rule = rule
        value = eval rule[:command]
        process_data rule[:zabbix_key], value
      end
    rescue Exception => e
      message = "#{current_zabbix_rule[:zabbix_key]} command: #{current_zabbix_rule[:command]} with message: #{e.message}"
      Zabbix.logger.error "[Monitor] failed collecting data for rule: #{message}"
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
        Zabbix.logger.info "[Monitor] successfully sended rule: '#{key}' to zabbix server: '#{config.host_name}'"
      else
        Zabbix.logger.error "[Monitor] failed sending rule: '#{key}' with value: '#{value}' to zabbix server: '#{config.host_name}'"
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
      Dir.mkdir 'tmp' unless Dir.exists? 'tmp'
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
      $stdout.puts "#{key}: #{value}"
    end
  end
end
