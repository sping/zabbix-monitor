# Zabbix Monitor Changelog

## v0.0.10 (2014-12-22)

- Require ActiveRecord 3.2 or higher

## v0.0.9 (2014-12-22)

- Fixed some logging, docs and specs
- Require ActiveRecord explicit
- Added Capistrano tasks to stop and start the daemon to make it work with God.rb, removed after deploy:restart rule

## v0.0.8 (2014-06-18)

- Made Yell log adapter configurable, defaults to :file

## v0.0.7 (2014-06-18)

- Don't log while setting mode because the logger could still be uninitialized
- Don't create a symlinked log, depond on log rotate instead
- Added some logging to see if the monitor is running

## v0.0.6 (2014-05-27)

- Moved pid files the the correct location

## v0.0.5 (2014-05-27)

- Fixed permissions issue in v0.0.4

## v0.0.4 (2014-05-27) (yanked)

- Added Capistrano 2 recipe

## v0.0.3 (2014-05-27)

- Added codeclimate coverage
- Puts results to the STDOUT
- Removed YAML dependency from reader
- Use Dante to daemonize the monitoring tasks

## v0.0.2 (2014-04-24)

- Added :file mode
    - Write monitoring data to `tmp/zabbix-stats.yml`
    - Read values with `$ zabbix_reader test`
- Added specs
- Added documentation
- Added services:
    - Travis CI
    - Rdoc

## v0.0.1 (2014-04-17)

- Initial release
