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
      allow(DramaQueen.subscriptions).to receive(:has_key?) { false }
    end

    it 'returns nil' do
      expect(subject.publish('test')).to be_nil
    end
  end

  describe '#publish with subscribers of a different topic' do
    before do
      DramaQueen.subscriptions[:another_topic] = true
    end

    it 'returns nil' do
      expect(subject.publish('test')).to be_nil
    end
  end

  describe '#publish with subscribers of a same topic' do
    let(:consumer) { double 'DramaQueen::Consumer' }
    let(:topic) { double 'DramaQueen::Topic' }

    before do
      DramaQueen.subscriptions['test'] = topic
    end

    context 'topic has no consumers' do
      before do
        allow(topic).to receive(:empty?) { true }
      end

      it 'does not call the callback' do
        expect(topic).to_not receive(:notify_with)
        expect(subject.publish('test')).to eq false
      end
    end

    context 'topic has consumers' do
      before do
        allow(topic).to receive(:empty?) { false }
      end

      it 'calls the callback' do
        expect(topic).to receive(:notify_with)
        expect(subject.publish('test')).to eq true
      end
    end
  end
end
