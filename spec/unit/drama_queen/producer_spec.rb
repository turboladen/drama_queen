require 'spec_helper'
require 'drama_queen/producer'


describe DramaQueen::Producer do
  subject { Object.new.extend(described_class) }

  let(:exchange) { double 'DramaQueen::Exchange', subscribers: [] }

  before do
    allow(DramaQueen).to receive(:exchange_for).with('test') { exchange }
  end

  describe '#publish' do
    context 'with no related exchanges' do
      context 'with no subscribers' do
        before do
          allow(exchange).to receive(:related_exchanges) { [] }
        end

        it 'returns false' do
          allow(exchange).to receive(:notify_with)
          expect(subject.publish('test', :an_arg)).to eq false
        end

        it 'calls #notify_with on the exchange' do
          expect(exchange).to receive(:notify_with).with(:an_arg)
          subject.publish('test', :an_arg)
        end
      end

      context 'with subscribers' do
        before do
          allow(exchange).to receive(:related_exchanges) { [] }
          exchange.subscribers << [1, 2]
        end

        it 'returns true' do
          allow(exchange).to receive(:notify_with)
          expect(subject.publish('test', :an_arg)).to eq true
        end

        it 'calls #notify_with on the exchange' do
          expect(exchange).to receive(:notify_with).with(:an_arg)
          subject.publish('test', :an_arg)
        end
      end
    end

    context 'with related exchanges' do
      let(:another_exchange) do
        double 'DramaQueen::Exchange'
      end

      before do
        allow(exchange).to receive(:related_exchanges) { [another_exchange] }
      end

      context 'with no subscribers' do
        before do
          allow(another_exchange).to receive(:subscribers) { [] }
        end

        it 'calls #notify_with' do
          expect(exchange).to receive(:notify_with).with(:an_arg)
          expect(another_exchange).to receive(:notify_with).with(:an_arg)
          subject.publish('test', :an_arg)
        end

        it 'returns false' do
          allow(exchange).to receive(:notify_with)
          allow(another_exchange).to receive(:notify_with)
          expect(subject.publish('test', :an_arg)).to eq false
        end
      end

      context 'with subscribers' do
        before do
          allow(another_exchange).to receive(:subscribers) { [1, 2] }
        end

        it 'calls #notify_with' do
          expect(exchange).to receive(:notify_with).with(:an_arg)
          expect(another_exchange).to receive(:notify_with).with(:an_arg)
          subject.publish('test', :an_arg)
        end

        it 'returns true' do
          allow(exchange).to receive(:notify_with)
          allow(another_exchange).to receive(:notify_with)
          expect(subject.publish('test', :an_arg)).to eq true
        end
      end
    end
  end
end
