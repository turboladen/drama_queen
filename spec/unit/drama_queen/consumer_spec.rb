require 'spec_helper'
require 'drama_queen/consumer'


describe DramaQueen::Consumer do
  subject do
    Object.new.extend(DramaQueen::Consumer)
  end

  let(:exchange) { double 'DramaQueen::Exchange', subscribers: [] }
  let(:callback) { double 'Method', call: true }

  describe '.included' do
    it 'adds the includer to the list of consumers' do
      consumer = Class.new do
        include DramaQueen::Consumer
      end

      expect(DramaQueen.consumers).to eq [consumer]
    end
  end

  describe '#exchanges' do
    context 'no exchanges defined yet' do
      it 'is created as an empty Array' do
        expect(subject.exchanges).to be_an_instance_of Array
      end
    end

    context 'exchanges without a consumer-known routing key are defined' do
      before do
        DramaQueen.exchanges['other key'] = true
      end

      it 'returns an empty Array' do
        expect(subject.exchanges).to eq []
      end
    end

    context 'exchanges with a consumer-known routing key are defined' do
      before do
        DramaQueen.exchanges['other key'] = exchange
        subject.instance_variable_set(:@routing_keys, ['other key'])
      end

      it 'returns an empty Array' do
        expect(subject.exchanges).to eq [exchange]
      end
    end
  end

  describe '#subscribe' do
    context 'routing key exists' do
      before do
        allow(DramaQueen).to receive(:routes_to?).with('test') { true }
      end

      it "find the exchange and adds itself to exchange's subscribers" do
        expect(DramaQueen.exchanges).to receive(:[]).and_return exchange
        expect(subject).to receive(:method).with(:call_me) { callback }

        subject.subscribe('test', :call_me)

        expect(exchange.subscribers).to eq [callback]
      end
    end

    context 'routing key does not exist' do
      before do
        allow(DramaQueen).to receive(:routes_to?).with('test') { false }
      end

      it "creates a new exchange and adds itself to exchange's subscribers" do
        expect(DramaQueen::Exchange).to receive(:new).with('test') { exchange }
        expect(subject).to receive(:method).with(:call_me) { callback }

        subject.subscribe('test', :call_me)

        expect(exchange.subscribers).to eq [callback]
      end
    end
  end

  describe '#unsubscribe' do
    context 'subject is subscribed to the given routing key' do
      before do
        allow(DramaQueen.exchanges).to receive(:has_key?).with('test_key').
          and_return(true)
      end

      let(:exchange) do
        double 'DramaQueen::Exchange'
      end

      it 'returns false' do
        expect(DramaQueen.exchanges).to receive(:[]).with('test_key').
          and_return exchange
        expect(exchange).to receive(:unsubscribe).with(subject).and_return true
        expect(subject.unsubscribe('test_key')).to eq true
      end
    end

    context 'subject is not subscribed to the given routing key' do
      it 'returns false' do
        expect(subject.unsubscribe('test_key')).to eq false
      end
    end

    context 'no one is subscribed to the given routing key' do
      before do
        allow(DramaQueen.exchanges).to receive(:has_key?).and_return false
      end

      it 'returns false' do
        expect(subject.unsubscribe('test_key')).to eq false
      end
    end
  end

  describe '#unsubscribe_all' do
    context 'no routing keys' do
      it 'returns false' do
        expect(subject.unsubscribe_all).to eq false
      end

      it 'does not try to unsubscribe from anything' do
        expect(subject).to_not receive(:unubscribe)
        expect(subject.send(:routing_keys)).to_not receive(:delete)

        subject.unsubscribe_all
      end
    end

    context 'has routing keys' do
      context 'unsubscribe fails' do
        before do
          allow(subject).to receive(:unsubscribe).and_return false
          allow(subject.send(:routing_keys)).to receive(:delete).and_return true
        end

        it 'returns false' do
          expect(subject.unsubscribe_all).to eq false
        end
      end

      context 'deleting routing key fails' do
        before do
          allow(subject).to receive(:unsubscribe).and_return true
          allow(subject.send(:routing_keys)).to receive(:delete).and_return false
        end

        it 'returns false' do
          expect(subject.unsubscribe_all).to eq false
        end
      end

      context 'deleting routing key and unsubscribe succeed' do
        before do
          subject.instance_variable_set(:@routing_keys, [1])
          allow(subject).to receive(:unsubscribe).and_return true
          allow(subject.send(:routing_keys)).to receive(:delete).and_return true
        end

        it 'returns false' do
          expect(subject.unsubscribe_all).to eq true
        end
      end
    end
  end
end
