require_relative '../drama_queen'


module DramaQueen
  module Publisher
    def publish(topic, *args)
      unless DramaQueen.subscribers.has_key? topic
        puts "no topic found fo: #{topic}"
        return
      end

      puts "publishing..."

      publisher = Fiber.new do
        DramaQueen.subscribers[topic][:fiber].resume(*args)
      end

      publisher.resume
    end
  end
end
