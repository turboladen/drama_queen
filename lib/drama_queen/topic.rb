require_relative 'consumer'


module DramaQueen
  class Topic
    include DramaQueen::Consumer

    # A SubscriberGroup is simply a collection of subscribers.  You probably don't
    # need to use this explicitly; this is what DramaQueen::Producer uses to
    # notify subscribers.
    #
    # @return [Array]
    attr_reader :subscribers

    attr_reader :key

    # @param [Object] obj
    def initialize(obj)
      @key = obj
      @subscribers = []
    end

    # @return [Array]
    def related_topic_keys
      return DramaQueen.topic_keys if self.key == '*'

      DramaQueen.topic_keys.find_all do |topic_key|
        if self.key.is_a?(String) && topic_key.is_a?(String)
          matcher = self.key.gsub('*', '\w+')
          matcher = "#{matcher}\\z"
          topic_key.match(Regexp.new(matcher))
        else
          topic_key == self.key
        end
      end
    end

    # @return [Array<DramaQueen::Topic>]
    def related_topics
      related_topic_keys.map do |topic_key|
        DramaQueen.subscriptions[topic_key]
      end
    end

    # Calls each subscriber's callback with the given arguments.
    #
    # @param args
    def notify_with(*args)
      @subscribers.each do |subscriber|
        subscriber.call(*args)
      end
    end

    def callback(*args)
      puts "called with args: #{args}"
    end
  end
end
