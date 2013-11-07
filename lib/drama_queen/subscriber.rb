require_relative '../drama_queen'
require_relative 'subscriber_group'


module DramaQueen
  module Subscriber
    def subscribe(topic, callback)
      callable_callback = callback.is_a?(Symbol) ? method(callback) : callback

      DramaQueen.subscribers[topic] ||= SubscriberGroup.new
      puts "group: #{DramaQueen.subscribers[topic]}"
      DramaQueen.subscribers[topic] << callable_callback
    end
  end
end
