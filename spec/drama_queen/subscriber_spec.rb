require_relative '../spec_helper'
require 'drama_queen/subscriber'


describe DramaQueen::Subscriber do
  subject do
    Object.new.extend(DramaQueen::Subscriber)
  end

  after do
    DramaQueen.unsubscribe_all
  end

  describe '#subscribe' do
    it 'adds itself to the list of subscribers' do
      DramaQueen.subscribers.must_be_empty

      subject.subscribe('test', :call_me)

      DramaQueen.subscribers.size.must_equal 1
      DramaQueen.subscribers['test'].must_equal [{ subscriber: subject,
        callback: :call_me }]
    end
  end
end
