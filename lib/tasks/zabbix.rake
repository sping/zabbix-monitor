require 'rufus-scheduler'

namespace :zabbix do
  task :get_statistics => :environment do
    Rufus::Scheduler.new.tap do |scheduler|
      scheduler.every '1m' do
        ActiveRecord::Base.connection_pool.with_connection do
          puts "HELLO"
        end
      end
    end.join
  end
end