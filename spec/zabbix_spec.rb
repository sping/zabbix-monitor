require 'spec_helper'

describe Zabbix do
  before :each do
    # reset config
    Zabbix.send(:config) { nil }
  end

  describe "#configure" do
    describe "basic config vars and behaviour" do

      it 'creates a new config for the Zabbix monitor instance' do
        Zabbix.config.should be_kind_of(Zabbix::Config)
      end
      it 'set the correct config values' do
        Zabbix.configure do |config|
          config.config_file_path = '/etc/zabbix/zabbix_agentd.conf'
          config.host_name = 'servername'
          config.mode = :push
        end

        Zabbix.config.config_file_path.should eq '/etc/zabbix/zabbix_agentd.conf'
        Zabbix.config.log_file_path.should be_nil
        Zabbix.config.host_name.should eq 'servername'
        Zabbix.config.mode.should eq :push
        pending 'should rules be initialized as an empty array?'
        Zabbix.config.rules.count.should eq 0
      end
      it 'returns the correct log_file_path if specified' do
        Zabbix.configure do |config|
          config.log_file_path = '/var/log/monitor.log'
        end
        Zabbix.config.log_file_path.should eq '/var/log/monitor.log'
      end
    end

    describe "rules" do
      it 'has one rule' do
        rule = { :command => 'a', :zabbix_key => 'a' }
        Zabbix.configure do |config|
          config.rules = [rule]
        end
        Zabbix.config.rules.should eq [rule]
      end
      it 'has two rules' do
        ruleA = { :command => 'a', :zabbix_key => 'a' }
        ruleB = { :command => 'b', :zabbix_key => 'b' }
        Zabbix.configure do |config|
          config.rules = [ruleA, ruleB]
        end
        Zabbix.config.rules.should eq [ruleA, ruleB]
      end
      it 'validates if the format of a rule from config is valid' do
        pending 'todo'
      end
    end
  end
end
