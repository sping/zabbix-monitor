require 'capistrano'

Capistrano::Configuration.instance.load do

  after 'deploy:update_code', 'zabbix:restart'

  namespace :zabbix do
    desc 'Restarting Zabbix monitoring'
    task :restart, :roles => :web do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake zabbix:restart"
    end
  end
end