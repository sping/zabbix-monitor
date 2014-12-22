require 'capistrano'

Capistrano::Configuration.instance.load do

  namespace :zabbix do
    desc 'Start Zabbix monitoring'
    task :start, :roles => :web do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake zabbix:start"
    end

    desc 'Stop Zabbix monitoring'
    task :stop, :roles => :web do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake zabbix:stop"
    end

    desc 'Restart Zabbix monitoring'
    task :restart, :roles => :web do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake zabbix:restart"
    end
  end
end