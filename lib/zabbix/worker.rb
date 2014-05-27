require 'light_daemon'

module Zabbix

  class Worker

    def call
      Zabbix::Monitor.new.schedule
    end

  end
end