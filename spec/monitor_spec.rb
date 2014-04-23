require 'spec_helper'

describe Zabbix::Monitor do
  let(:logger)  { Zabbix.logger }
  let(:monitor) { Zabbix::Monitor.new }
  let(:config)  { Zabbix::Config.new }

  before :each do
    Zabbix.stub(:config) { config }
  end

  describe "#config" do
    it 'returns the Zabbix monitor instance config' do
      monitor.send(:config).should eq config
    end
  end

  describe "#collect_data" do
    # 'process data'
    # 'raise exception invalid rule, invalid command, no command'
    describe "one rule" do
      before :each do
        config.stub(:rules) {[
          { :command => 'cmd', :zabbix_key => 'some.key' }
        ]}
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
        config.stub(:rules) {[
          { :command => 'cmd', :zabbix_key => 'some.key' },
          { :command => 'cmd', :zabbix_key => 'another.key' }
        ]}
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
      monitor.stub(:puts) {}
      monitor.send(:to_zabbix, 'key', 'value')
    end
    it 'outputs GREAT if the command is executed without errors' do
      monitor.stub(:'`') { `(exit 0)` }
      expect(logger).to receive(:info).with(/successfully sended rule: 'key' to zabbix server: 'servername'/)
      monitor.send(:to_zabbix, 'key', 'value')
    end
    it 'outputs BUMMER if the command is executed with an error' do
      monitor.stub(:'`') { `(exit -1)` }
      expect(logger).to receive(:error).with(/failed sending rule: 'key' with value: 'value' to zabbix server: 'servername'/)
      monitor.send(:to_zabbix, 'key', 'value')
    end
  end

  describe "#to_file" do
    pending 'not implemented yet'

    # just to have that 100% coverage!
    it 'raises a exception' do
      expect {
        monitor.send(:to_file, 'key', 'the value')
      }.to raise_error(StandardError, 'Write to file is not implemented yet')
    end
  end

  describe "#to_stdout" do
    it 'receives the key and value as a puts command' do
      expect(monitor).to receive(:puts).with('key: the value')
      monitor.send(:to_stdout, 'key', 'the value')
    end
  end
end
