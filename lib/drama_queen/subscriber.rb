require_relative '../drama_queen'


module DramaQueen
  module Subscriber
    def subscribe(topic, callback)
      callable_callback = if callback.is_a? Symbol
        method(callback)
      else
        callback
      end

      unless DramaQueen.subscribers.has_key? topic
        DramaQueen.subscribers[topic] = {}
        DramaQueen.subscribers[topic][:callables] = []

        DramaQueen.subscribers[topic][:fiber] = Fiber.new do |args|
          loop do
            #puts "fiber args: #{args}"

            DramaQueen.subscribers[topic][:callables].each_with_index do |callable, i|
              #puts "subscriber: #{i}"
              callable.call(args)
            end

            Fiber.yield
          end
        end
      end

      DramaQueen.subscribers[topic][:callables] << lambda { |args|
        callable_callback.call(*args)
      }

      #puts "topic size: #{DramaQueen.subscribers[topic][:callables].count}"
      #puts "topics: #{DramaQueen.subscribers.keys}"
    end
  end
end
