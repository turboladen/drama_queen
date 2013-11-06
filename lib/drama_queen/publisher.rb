require_relative '../drama_queen'


module DramaQueen
  module Publisher
    def publish(topic, *args)
      unless DramaQueen.subscribers.has_key? topic
        raise "No topic found for: #{topic}"
      end

      DramaQueen.subscribers[topic].notify_with(*args)
    end
  end
end
