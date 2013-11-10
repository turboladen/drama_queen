require_relative '../drama_queen'


module DramaQueen

  # A +producer+ is an object that has content to provide on a +topic+.  When
  # it decides it has content to +publish+ on that topic, it simply passes that
  # info on to all of the +consumer+s that have +subscribe+d to the topic.
  # Actually, it doesn't have to pass any info on--it can simply act like a ping
  # to the subscribers; this is up to how you want to use them.
  module Producer

    # @param topic_key
    # @param args
    def publish(topic_key, *args)
      unless DramaQueen.subscriptions.has_key? topic_key
        puts "Topics: #{DramaQueen.subscriptions.keys.join(', ')}"
        warn "No topic found for: #{topic_key}"

        return
      end

      if DramaQueen.subscriptions[topic_key].empty?
        return false
      else
        DramaQueen.subscriptions[topic_key].notify_with(*args)
      end

      true
    end
  end
end
