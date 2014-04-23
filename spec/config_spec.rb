require 'spec_helper'

describe Zabbix::Config do

  let(:logger) { Zabbix.logger }
  let(:config) { Zabbix::Config.new }

  describe '#mode' do
    it 'allows setting mode to push' do
      expect(logger).to receive(:info).with(/setting mode to 'push'/)
      config.mode = :push
    end
    it 'allows setting mode to file' do
      expect(logger).to receive(:info).with(/setting mode to 'file'/)
      config.mode = :file
    end
    it 'allows setting mode to stdout' do
      expect(logger).to receive(:info).with(/setting mode to 'stdout'/)
      config.mode = :stdout
    end
    it 'raises an unsupported mode for a invalid mode' do
      expect(logger).to receive(:error).with(/failed setting mode to 'wrong'/)
      expect { config.mode = :wrong }
        .to raise_error(StandardError, 'Unsupported mode: wrong')
    end
    it 'raises an unsupported mode for a empty mode' do
      expect(logger).to receive(:error).with(/failed setting mode to ''/)
      expect { config.mode = '' }
        .to raise_error(StandardError, 'Unsupported mode: ')
    end
  end
end
