require 'spec_helper'
require 'drama_queen/consumer'


describe DramaQueen::Consumer do
  subject do
    Object.new.extend(DramaQueen::Consumer)
  end

  let(:exchange) { double 'DramaQueen::Exchange', subscribers: [] }
  let(:callback) { double 'Method', call: true }

  describe '#subscribe' do
    before do
      allow(DramaQueen).to receive(:exchange_for).with('test') { exchange }
    end

    context 'routing key exists' do
      before do
        allow(DramaQueen).to receive(:routes_to?).with('test') { true }
      end

      it "creates a new exchange and adds itself to exchange's subscribers" do
        expect(DramaQueen.exchanges).to_not receive(:<<)
        expect(subject).to receive(:method).with(:call_me) { callback }

        subject.subscribe('test', :call_me)

        expect(exchange.subscribers).to eq [callback]
      end
    end

    context 'routing key does not exist' do
      before do
        allow(DramaQueen).to receive(:routes_to?).with('test') { false }
      end

      it "find the exchange and adds itself to exchange's subscribers" do
        expect(DramaQueen::Exchange).to receive(:new).with('test') { exchange }
        expect(DramaQueen.exchanges).to receive(:<<).with(exchange)
        expect(subject).to receive(:method).with(:call_me) { callback }

        subject.subscribe('test', :call_me)

        expect(exchange.subscribers).to eq [callback]
      end
    end
  end
end
