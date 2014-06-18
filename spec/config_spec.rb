require 'spec_helper'

describe Zabbix::Config do

  let(:logger) { Zabbix.logger }
  let(:config) { Zabbix::Config.new }

  describe '#mode' do
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
