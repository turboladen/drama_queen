require 'spec_helper'
require 'drama_queen/consumer'


describe DramaQueen::Consumer do
  subject do
    Object.new.extend(DramaQueen::Consumer)
  end

  describe '#subscribe' do
    context 'with a Symbol callback' do
      context 'routing key exists' do
        let(:routing_key) { double 'DramaQueen::RoutingKey' }
        let(:topic) { double 'DramaQueen::Topic', subscribers: [] }

        before do
          allow(DramaQueen).to receive(:routes_to?).with('test') { true }
          allow(DramaQueen).to receive(:routing_key_by_primitive).with('test') { routing_key }
          allow(DramaQueen.subscriptions).to receive(:[]).with(routing_key) { topic }
        end

        it 'adds itself to the list of subscribers' do
          callback = double 'Method', call: true

          expect(subject).to_not receive(:add_topic_for)
          expect(subject).to receive(:method).with(:call_me) { callback }

          subject.subscribe('test', :call_me)

          expect(topic.subscribers).to eq [callback]
        end
      end
    end
  end

  describe '#add_topic_for' do
    let(:routing_key) { double 'DramaQueen::RoutingKey' }
    let(:topic) { double 'DramaQueen::Topic' }

    it 'creates a new RoutingKey and Topic and adds those to the subscriptions list' do
      new_routing_key = 'test_routing_key'
      expect(DramaQueen::Exchange).to receive(:new).with(new_routing_key) { routing_key }
      expect(DramaQueen::Topic).to receive(:new) { topic }
      expect(DramaQueen.subscriptions).to receive(:[]=).with(routing_key, topic)

      subject.send(:add_topic_for, new_routing_key)
    end
  end
end
