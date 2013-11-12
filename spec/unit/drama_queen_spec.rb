require 'spec_helper'
require 'drama_queen'


describe DramaQueen do
  subject do
    described_class
  end

  let(:exchange) { double 'DramaQueen::Exchange' }

  describe '.exchanges' do
    it 'is created as an empty Array' do
      expect(subject.exchanges).to be_an_instance_of Array
    end
  end

  describe '.exchange_for' do
    before do
      allow(subject).to receive(:exchanges) { [exchange] }
    end

    context 'does not route' do
      before { allow(exchange).to receive(:routing_key) { 'another key' } }
      specify { expect(subject.exchange_for 'test_key').to eq nil }
    end

    context 'does route' do
      before { allow(exchange).to receive(:routing_key) { 'test_key' } }
      specify { expect(subject.exchange_for 'test_key').to eq exchange }
    end
  end

  describe '.routes_to?' do
    before do
      allow(subject).to receive(:exchanges) { [exchange] }
    end

    context 'does not route' do
      before do
        allow(subject).to receive(:exchange_for).
          with('test_key') { false }
      end

      specify { expect(subject.routes_to? 'test_key').to eq false }
    end

    context 'does route' do
      before do
        allow(subject).to receive(:exchange_for).
          with('test_key') { true }
      end

      specify { expect(subject.routes_to? 'test_key').to eq true }
    end
  end
end
