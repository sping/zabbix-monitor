require 'zabbix'
require 'dante'

namespace :zabbix do
  desc 'Collect data for Zabbix'
  task :run_once => :environment do
    Zabbix.logger.info "[Rake] executing #collect_once"
    Zabbix::Monitor.new.collect_data
  end

  desc 'Collect data for Zabbix every minute'
  task :start => :environment do
    Zabbix.logger.info "[Rake] executing #start, setting up Rufus"
    Dante::Runner.new('zabbix-monitor').execute(:daemonize => true, :pid_path => 'tmp/pids/zabbix-monitor.pid', :log_path => 'log/zabbix-monitor.log') do
      Zabbix::Monitor.new.schedule
    end
  end

  desc 'Stop collecting data for Zabbix'
  task :stop => :environment do
    Zabbix.logger.info "[Rake] executing #stop, stopping daemon"
    Dante::Runner.new('zabbix-monitor').execute(:kill => true, :pid_path => 'tmp/pids/zabbix-monitor.pid')
  end

  desc 'Restart collecting data for Zabbix'
  task :restart => :environment do
    Zabbix.logger.info "[Rake] executing #stop, stopping daemon"
    Dante::Runner.new('zabbix-monitor').execute(:daemonize => true, :restart => true, :pid_path => 'tmp/pids/zabbix-monitor.pid', :log_path => 'log/zabbix-monitor.log') do
      Zabbix::Monitor.new.schedule
    end
  end
end