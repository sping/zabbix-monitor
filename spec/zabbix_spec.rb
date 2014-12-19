require 'spec_helper'

describe Zabbix do
  before :each do
    # reset config
    Zabbix.send(:config) { nil }
  end

  describe "#configure" do
    describe "basic config vars and behaviour" do

      it 'creates a new config for the Zabbix monitor instance' do
        expect(Zabbix.config).to be_kind_of(Zabbix::Config)
      end
      it 'set the correct config values' do
        Zabbix.configure do |config|
          config.config_file_path = '/etc/zabbix/zabbix_agentd.conf'
          config.host_name = 'servername'
          config.mode = :push
        end

        expect(Zabbix.config.config_file_path).to eq '/etc/zabbix/zabbix_agentd.conf'
        expect(Zabbix.config.log_file_path).to be_nil
        expect(Zabbix.config.host_name).to eq 'servername'
        expect(Zabbix.config.mode).to eq :push
        pending 'should rules be initialized as an empty array?'
        expect(Zabbix.config.rules.count).to eq 0
      end
      it 'returns the correct log_file_path if specified' do
        Zabbix.configure do |config|
          config.log_file_path = '/var/log/monitor.log'
        end
        expect(Zabbix.config.log_file_path).to eq '/var/log/monitor.log'
      end
    end

    describe "rules" do
      it 'has one rule' do
        rule = { :command => 'a', :zabbix_key => 'a' }
        Zabbix.configure do |config|
          config.rules = [rule]
        end
        expect(Zabbix.config.rules).to eq [rule]
      end
      it 'has two rules' do
        ruleA = { :command => 'a', :zabbix_key => 'a' }
        ruleB = { :command => 'b', :zabbix_key => 'b' }
        Zabbix.configure do |config|
          config.rules = [ruleA, ruleB]
        end
        expect(Zabbix.config.rules).to eq [ruleA, ruleB]
      end
      it 'validates if the format of a rule from config is valid'
    end
  end
end
