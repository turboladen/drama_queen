require 'spec_helper'
require 'drama_queen/producer'


describe DramaQueen::Producer do
  subject do
    Object.new.extend(described_class)
  end

  before do
    DramaQueen.unsubscribe_all
  end

  describe '#publish with no subscribers' do
    before do
      allow(DramaQueen.subscribers).to receive(:has_key?) { false }
    end

    it 'returns nil' do
      expect(subject.publish('test')).to be_nil
    end
  end

  describe '#publish with subscribers of a different topic' do
    before do
      DramaQueen.subscribers[:another_topic] = true
    end

    it 'returns nil' do
      expect(subject.publish('test')).to be_nil
    end
  end

  describe '#publish with subscribers of a same topic' do
    let(:consumer) { double 'Consumer' }
    let(:subscriber_group) do
      [{
        subscriber: consumer,
        callback: :test_method
      }]
    end

    before do
      DramaQueen.subscribers['test'] = subscriber_group
    end

    it 'calls the callback' do
      expect(subscriber_group).to receive(:notify_with)
      expect(subject.publish('test')).to eq true
    end
  end
end
