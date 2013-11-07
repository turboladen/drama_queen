require_relative '../drama_queen'


module DramaQueen
  module Publisher
    def publish(topic, *args)
      unless DramaQueen.subscribers.has_key? topic
        puts "Topics: #{DramaQueen.subscribers.keys.join(', ')}"
        warn "No topic found for: #{topic}"
      end

      unless DramaQueen.subscribers[topic].empty?
        DramaQueen.subscribers[topic].notify_with(*args)
      end
    end
  end
end
