require 'spec_helper'
require 'drama_queen/producer'


describe DramaQueen::Producer do
  subject do
    Object.new.extend(described_class)
  end

  before do
    DramaQueen.unsubscribe_all
  end

  describe '#publish' do
    context 'with no subscribers' do
      it 'returns false' do
        expect(subject.publish('test')).to eq false
      end
    end

    context 'with subscribers of a same topic' do
      let(:exchange) { double 'DramaQueen::Exchange' }

      before do
        allow(DramaQueen::Exchange).to receive(:new) { exchange }
      end

      context 'topic has no consumers' do
        before do
          allow(exchange).to receive(:related_keys) { [] }
        end

        it 'does not call the callback' do
          expect(subject.publish('test')).to eq false
        end
      end

      context 'topic has consumers' do
        let(:topic) { double 'DramaQueen::Topic' }

        before do
          allow(exchange).to receive(:related_keys) { [exchange] }
          allow(DramaQueen.subscriptions).to receive(:[]).with(exchange) { topic }
        end

        it 'calls the callback' do
          expect(topic).to receive(:notify_with)
          expect(subject.publish('test')).to eq true
        end
      end
    end
  end
end
