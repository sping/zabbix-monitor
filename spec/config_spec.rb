require 'spec_helper'

describe Zabbix::Config do
  let(:config) { Zabbix::Config.new }

  describe '#mode' do
    it 'allows setting mode to push' do
      config.mode = :push
    end
    it 'allows setting mode to file' do
      config.mode = :file
    end
    it 'allows setting mode to stdout' do
      config.mode = :stdout
    end
    it 'raises an unsupported mode for a invalid mode' do
      expect { config.mode = :wrong }
        .to raise_error(StandardError, 'Unsupported mode: wrong')
    end
    it 'raises an unsupported mode for a empty mode' do
      expect { config.mode = '' }
        .to raise_error(StandardError, 'Unsupported mode: ')
    end
  end
end
