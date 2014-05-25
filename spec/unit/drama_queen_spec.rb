require 'spec_helper'
require 'drama_queen'


describe DramaQueen do
  subject do
    described_class
  end

  let(:exchange) { double 'DramaQueen::Exchange' }

  describe '.consumers' do
    it 'is created as an empty Array' do
      expect(subject.consumers).to be_an_instance_of Array
    end
  end

  describe '.exchanges' do
    let :consumer do
      double 'DramaQueen::Consumer', exchanges: []
    end

    before do
      allow(subject).to receive(:consumers).and_return [consumer]
    end

    it 'is created as an empty Hash' do
      expect(subject.exchanges).to be_an_instance_of Hash
    end
  end

  describe '.producers' do
    it 'is created as an empty Array' do
      expect(subject.producers).to be_an_instance_of Array
    end
  end

  describe '.routes_to?' do
    context 'does not route' do
      before do
        allow(subject).to receive(:exchanges) { { 'not_test_key' => [exchange] } }
      end

      specify { expect(subject.routes_to? 'test_key').to eq false }
    end

    context 'does route' do
      before do
        allow(subject).to receive(:exchanges) { { 'test_key' => [exchange] } }
      end

      specify { expect(subject.routes_to? 'test_key').to eq true }
    end
  end
end
