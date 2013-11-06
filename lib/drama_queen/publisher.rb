require_relative '../drama_queen'


module DramaQueen
  module Publisher
    def publish(topic, *args)
      return unless DramaQueen.subscribers.has_key? topic
      puts "publishing..."

      publisher = Fiber.new do
        DramaQueen.subscribers[topic][:fiber].resume(*args)
      end

      publisher.resume
    end
  end
end
