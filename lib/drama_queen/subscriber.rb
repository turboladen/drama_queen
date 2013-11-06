require_relative '../drama_queen'


module DramaQueen
  module Subscriber
    def subscribe(topic, callback)
      DramaQueen.subscribers[topic] ||= []

      callable_callback = if callback.is_a? Symbol
        method(callback)
      elsif callback.respond_to? :call
        callback
      else
        raise ArgumentError, "'#{callback}' is not a valid callback parameter."
      end

      DramaQueen.subscribers[topic] << {
        subscriber: self,
        callback: callable_callback
      }
    end
  end
end
