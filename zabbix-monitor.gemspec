# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'zabbix-monitor'
  spec.version       = '0.0.8'
  spec.authors       = ['Robert Jan de Gelder', 'Manuel van Rijn']
  spec.email         = ['r.degelder@sping.nl', 'm.vanrijn@sping.nl']
  spec.description   = 'Zabbix application monitoring'
  spec.summary       = 'Let the Zabbix agent read your application monitoring'
  spec.homepage      = 'http://rubygems.org/gems/zabbix-monitor'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rufus-scheduler', '~> 3.0'
  spec.add_dependency 'yell', '~> 2.0'
  spec.add_dependency 'dante', '~> 0.2.0'
  spec.add_dependency 'activerecord', '>= 4.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
