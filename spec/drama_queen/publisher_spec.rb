require_relative '../spec_helper'
require 'minitest/mock'
require 'drama_queen/publisher'


describe DramaQueen::Publisher do
  subject do
    Object.new.extend(DramaQueen::Publisher)
  end

  describe '#publish with no subscribers' do
    before do
      DramaQueen.subscribers.stub(:has_key?, false) do
        false
      end
    end

    it 'returns nil' do
      subject.publish('test').must_equal nil
    end
  end

  describe '#publish with subscribers of a different topic' do
    before do
      DramaQueen.subscribers[:another_topic] = true
    end

    it 'returns nil' do
      subject.publish('test').must_equal nil
    end
  end

  describe '#publish with subscribers of a same topic' do
    let(:subscriber) { MiniTest::Mock.new }

    before do
      DramaQueen.subscribers['test'] = [{
        subscriber: subscriber,
        callback: :test_method
      }]
    end

    it 'calls the callback' do
      subscriber.expect :send, true, [:test_method, []]
      subject.publish('test')
    end
  end
end
