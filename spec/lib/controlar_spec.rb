require 'spec_helper'

describe Controlar do
  describe '.config' do
    let(:config) { described_class.config {} }
    it 'returns a ConfigDSL object' do
      expect(config).to be_a(Controlar::ConfigDSL)
    end
  end

  describe '.shutdown!' do
    let(:shutdown!) { described_class.shutdown! }

    it 'calles' do
      expect(described_class).to receive(:exit)
      shutdown!
    end
  end
end
