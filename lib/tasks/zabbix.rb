require 'zabbix'
require 'rufus-scheduler'

namespace :zabbix do
  desc 'Collect data for Zabbix'
  task :collect_once => :environment do
    Zabbix.logger.info "[Rake] executing #collect_once"
    Zabbix::Monitor.new.collect_data
  end

  desc 'Collect data for Zabbix every minute'
  task :collect_data => :environment do
    Zabbix.logger.info "[Rake] executing #collect_data, setting up Rufus"
    Rufus::Scheduler.new.tap do |scheduler|
      scheduler.every '1m' do
        ActiveRecord::Base.connection_pool.with_connection do
          Zabbix::Monitor.new.collect_data
        end
      end
    end.join
  end
end
