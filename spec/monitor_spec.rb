require 'spec_helper'

describe Zabbix::Monitor do
  let(:logger)  { Zabbix.logger }
  let(:monitor) { Zabbix::Monitor.new }
  let(:config)  { Zabbix::Config.new }

  before :each do
    allow(Zabbix).to receive(:config).and_return(config)
  end

  describe "#config" do
    it 'returns the Zabbix monitor instance config' do
      expect(Zabbix).to receive(:config)
      monitor.send(:config)
    end
  end

  describe '#scheduled_collect_data' do
    it 'calls the #collect_data with an ActiveRecord connection from the pool' do
      fake_connection = double
      allow(fake_connection).to receive(:with_connection).and_yield
      allow(ActiveRecord::Base).to receive(:connection_pool).and_return fake_connection
      expect(monitor).to receive(:collect_data).once
      monitor.send(:scheduled_collect_data)
    end
  end

  describe '#schedule' do
    let(:fake_rufus) { double }
    let(:fake_collect_data) { double }

    it 'schedule the data collector to run every minute' do
      allow(fake_collect_data).to receive(:join)
      allow(fake_rufus).to receive(:every).and_yield

      expect_any_instance_of(Rufus::Scheduler).to receive(:tap).and_yield fake_rufus
      expect(monitor).to receive(:scheduled_collect_data).once.and_return fake_collect_data
      monitor.schedule
    end
  end

  describe "#collect_data" do
    # 'process data'
    # 'raise exception invalid rule, invalid command, no command'
    describe "one rule" do
      before :each do
        allow(config).to receive(:rules).and_return([
          { :command => 'cmd', :zabbix_key => 'some.key' }
        ])
      end
      it 'executes the command once and passes it to process' do
        expect(monitor).to receive(:eval).once.and_return("result")
        expect(monitor).to receive(:process_data).once.with('some.key', 'result')
        monitor.collect_data
      end
      it 'catches the exception if command can not be excuted' do
        exception = Exception.new("some error description")
        expect(monitor).to receive(:eval).and_raise(exception)
        expect(monitor).not_to receive(:process_data)
        expect(logger).to receive(:error).with(/some.key command: cmd with message: some error description/)
        monitor.collect_data
      end
    end
    describe "two rules" do
      before :each do
        rules = [
          { :command => 'cmd', :zabbix_key => 'some.key' },
          { :command => 'cmd', :zabbix_key => 'another.key' }
        ]
        allow(config).to receive(:rules).and_return rules
      end
      it 'executes the command once and passes it to process' do
        expect(monitor).to receive(:eval).twice.and_return("result")
        expect(monitor).to receive(:process_data).once.with('some.key', 'result')
        expect(monitor).to receive(:process_data).once.with('another.key', 'result')
        monitor.collect_data
      end
    end
  end

  describe "#process_data" do
    it 'triggers the #to_zabbix for :push' do
      config.mode = :push

      expect(monitor).to receive(:to_zabbix).once.with(1, 2)
      monitor.send(:process_data, 1, 2)
    end
    it 'triggers the #to_file for :file' do
      config.mode = :file

      expect(monitor).to receive(:to_file).once.with(1, 2)
      monitor.send(:process_data, 1, 2)
    end
    it 'triggers the #stdout for :stdout' do
      config.mode = :stdout

      expect(monitor).to receive(:to_stdout).once.with(1, 2)
      monitor.send(:process_data, 1, 2)
    end
  end

  describe "#to_zabbix" do
    before do
      config.config_file_path = '/zabbix.conf'
      config.host_name = 'servername'
    end
    it 'executes the zabbix_sender command with the correct arguments' do
      expect(monitor).to receive(:'`').once.with('zabbix_sender -c /zabbix.conf -s "servername" -k key -o value')
      allow(monitor).to receive(:puts)
      monitor.send(:to_zabbix, 'key', 'value')
    end
    it 'outputs GREAT if the command is executed without errors' do
      allow(monitor).to receive(:'`').and_return(`(exit 0)`)
      expect(logger).to receive(:info).with(/successfully sent rule: 'key' with value: 'value' to zabbix server: 'servername'/)
      monitor.send(:to_zabbix, 'key', 'value')
    end
    it 'outputs BUMMER if the command is executed with an error' do
      allow(monitor).to receive(:'`').and_return(`(exit 1)`)
      expect(logger).to receive(:error).with(/failed sending rule: 'key' with value: 'value' to zabbix server: 'servername'/)
      monitor.send(:to_zabbix, 'key', 'value')
    end
  end

  describe "#to_file" do
    before :each do
      allow(File).to receive(:exists?).and_return false
      allow(File).to receive(:open).with('tmp/zabbix-stats.yml', 'w')
    end
    it 'creates the tmp folder if it does not exist' do
      expect(Dir).to receive(:mkdir).once.with('tmp')
      expect(Dir).to receive(:exists?).once.with('tmp').and_return(false)
      monitor.send(:to_file, 'key', 'value')
    end
    it 'will not create the tmp folder if it already exists' do
      expect(Dir).not_to receive(:mkdir).with('tmp')
      expect(Dir).to receive(:exists?).once.with('tmp').and_return(true)
      monitor.send(:to_file, 'key', 'value')
    end
    before :each do
      allow(Dir).to receive(:exists?).and_return true
    end
    describe 'writeing and reading' do
      it 'writes the result to "tmp/zabbix-stats.yml"' do
        allow(File).to receive(:exists?).and_return false
        file = double('file')
        yml = {'statistics' => {'created_at' => Time.now.to_i, 'key' => 'value'}}

        expect(File).to receive(:open).with('tmp/zabbix-stats.yml', 'w').and_yield(file)
        expect(file).to receive(:write).with(yml.to_yaml)
        monitor.send(:to_file, 'key', 'value')
      end
      it 'adds the key and value to the output file if it already exists' do
        allow(File).to receive(:exists?).and_return true
        file = double('file')
        yml = {'statistics' => {'created_at' => Time.now.to_i, 'old_key' => 'old_value'}}

        expect(YAML).to receive(:load_file).once.with('tmp/zabbix-stats.yml').and_return(yml)
        expect(File).to receive(:open).with('tmp/zabbix-stats.yml', 'w').and_yield(file)

        yml['statistics']['key'] = 'value'
        expect(file).to receive(:write).with(yml.to_yaml)
        monitor.send(:to_file, 'key', 'value')
      end
    end
  end

  describe "#to_stdout" do
    it 'receives the key and value as a puts command' do
      expect(STDOUT).to receive(:puts).with('key: the value')
      monitor.send(:to_stdout, 'key', 'the value')
    end
  end
end
