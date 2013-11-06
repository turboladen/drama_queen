require_relative '../drama_queen'
require_relative 'subscriber_group'


module DramaQueen
  module Subscriber
    def subscribe(topic, callback)
      callable_callback = callback.is_a?(Symbol) ? method(callback) : callback

      DramaQueen.subscribers[topic] ||= SubscriberGroup.new
      DramaQueen.subscribers[topic] << callable_callback

      #puts "topic size: #{DramaQueen.subscribers[topic].count}"
      #puts "topics: #{DramaQueen.subscribers.keys}"
    end
  end
end
