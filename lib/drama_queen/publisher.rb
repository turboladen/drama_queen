require_relative '../drama_queen'


module DramaQueen
  module Publisher
    def publish(topic, *args)
      return unless DramaQueen.subscribers.has_key? topic

      DramaQueen.subscribers[topic].each do |s|
        s[:subscriber].send(s[:callback], args)
      end
    end
  end
end
