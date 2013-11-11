require 'spec_helper'
require 'drama_queen/consumer'
require 'drama_queen/producer'

class BigPublisher
  include DramaQueen::Producer

  def do_stuff
    publish 'stuff1', 'the stuff1'
    publish 'stuff2', 'the stuff2'
    publish 'stuff5', 'the stuff3'
    publish 'stuff3', 'the stuff4'
    publish 'stuff5', 'the stuff5'
  end
end

class BigConsumer
  include DramaQueen::Consumer

  def initialize(callback1, callback2)
    100000.times do
      subscribe 'stuff1', callback1
      subscribe 'stuff2', callback2
      subscribe 'stuff3', callback1
      subscribe 'stuff4', callback2
      subscribe 'stuff5', ->(arg) {
        #puts arg
      }
    end
  end
end

class A
  include DramaQueen::Consumer

  def initialize(callback)
    subscribe 'root.*.children', callback
  end

  def call_me(*args)
    puts "A got called with args: #{args}"
  end
end

class B
  include DramaQueen::Producer

  def do_stuff
    publish 'root.parent', 1, 2, 3
  end
end

class C
  include DramaQueen::Producer

  def do_stuff
    publish 'root.parent.children', 'one', 'two', 'three'
  end
end

describe 'Draaaamaaaa' do
  before do
    DramaQueen.unsubscribe_all
  end

  describe 'lots of action' do
    it 'calls all of the things' do
      callback1 = Proc.new {}
      callback2 = Proc.new {}
      expect(callback1).to receive(:call).at_least(10000).times.with('the stuff1')
      expect(callback1).to receive(:call).at_least(10000).times.with('the stuff4')
      expect(callback2).to receive(:call).at_least(10000).times.with('the stuff2')
      expect(callback2).to receive(:call).at_most(10002)

      a = BigPublisher.new
      b = BigConsumer.new(callback1, callback2)

      a.do_stuff
      b.subscribe 'things', ->(arg) { puts arg }

      a.do_stuff
      a.publish 'things', 'hi'
    end
  end

  describe 'topic matching' do
    it 'calls only the topics that match' do
      callback = Proc.new {}
      #expect(callback).to receive(:call).with 'one', 'two', 'three'
      expect(callback).to receive(:call)

      a = A.new(callback)
      b = B.new
      c = C.new

      b.do_stuff
      c.do_stuff
    end
  end
end
