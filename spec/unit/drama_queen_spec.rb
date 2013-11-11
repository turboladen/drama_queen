require 'spec_helper'
require 'drama_queen'


describe DramaQueen do
  subject do
    described_class
  end

  describe '.subscribers' do
    it 'is created as an empty Hash' do
      expect(subject.subscriptions).to be_an_instance_of Hash
    end
  end

  describe '.routing_key_by_primitive' do
    let(:routing_key) { double 'DramaQueen::RoutingKey' }

    before do
      allow(subject).to receive(:exchanges) { [routing_key] }
    end

    context 'does not route' do
      before { allow(routing_key).to receive(:routing_key) { 'another key' } }
      specify { expect(subject.routing_key_by_primitive 'test_key').to eq nil }
    end

    context 'does route' do
      before { allow(routing_key).to receive(:routing_key) { 'test_key' } }
      specify { expect(subject.routing_key_by_primitive 'test_key').to eq routing_key }
    end
  end

  describe '.routes_to?' do
    let(:routing_key) { double 'DramaQueen::RoutingKey' }

    before do
      allow(subject).to receive(:exchanges) { [routing_key] }
    end

    context 'does not route' do
      before do
        allow(subject).to receive(:routing_key_by_primitive).
          with('test_key') { false }
      end

      specify { expect(subject.routes_to? 'test_key').to eq false }
    end

    context 'does route' do
      before do
        allow(subject).to receive(:routing_key_by_primitive).
          with('test_key') { true }
      end

      specify { expect(subject.routes_to? 'test_key').to eq true }
    end
  end
end
