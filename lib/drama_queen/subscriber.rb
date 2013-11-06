require_relative '../drama_queen'


module DramaQueen
  module Subscriber
    def subscribe(topic, callback)
      DramaQueen.subscribers[topic] ||= []

      DramaQueen.subscribers[topic] << {
        subscriber: self,
        callback: callback
      }
    end
  end
end
