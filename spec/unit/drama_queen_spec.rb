require 'spec_helper'
require 'drama_queen'


describe DramaQueen do
  subject do
    described_class
  end

  let(:exchange) { double 'DramaQueen::Exchange' }

  describe '.subscribers' do
    it 'is created as an empty Hash' do
      expect(subject.subscriptions).to be_an_instance_of Hash
    end
  end

  describe '.exchange_by_routing_key' do
    before do
      allow(subject).to receive(:exchanges) { [exchange] }
    end

    context 'does not route' do
      before { allow(exchange).to receive(:routing_key) { 'another key' } }
      specify { expect(subject.exchange_by_routing_key 'test_key').to eq nil }
    end

    context 'does route' do
      before { allow(exchange).to receive(:routing_key) { 'test_key' } }
      specify { expect(subject.exchange_by_routing_key 'test_key').to eq exchange }
    end
  end

  describe '.routes_to?' do
    before do
      allow(subject).to receive(:exchanges) { [exchange] }
    end

    context 'does not route' do
      before do
        allow(subject).to receive(:exchange_by_routing_key).
          with('test_key') { false }
      end

      specify { expect(subject.routes_to? 'test_key').to eq false }
    end

    context 'does route' do
      before do
        allow(subject).to receive(:exchange_by_routing_key).
          with('test_key') { true }
      end

      specify { expect(subject.routes_to? 'test_key').to eq true }
    end
  end
end
