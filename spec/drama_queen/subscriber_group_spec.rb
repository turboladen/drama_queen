require 'spec_helper'
require 'drama_queen/subscriber_group'


describe DramaQueen::SubscriberGroup do
  describe '#notify_with' do
    context 'list is empty' do
      it 'does not raise an error' do
        expect { subject.notify_with('stuff') }.to_not raise_exception
      end
    end

    context 'list is not empty' do
      it 'it #calls each subscriber with the given args' do
        subscriber = double 'Subscriber'
        subject << subscriber
        expect(subscriber).to receive('call').with(1, 2, 3)

        subject.notify_with 1, 2, 3
      end
    end
  end
end
