module DramaQueen

  # A Topic is the thing that consumers subscribe to.  You probably don't
  # need to use this explicitly; this is what DramaQueen::Producer uses to
  # notify subscribers.
  class Topic

    # @return [Array]
    attr_reader :subscribers

    # @return [Object]
    attr_reader :exchange

    # @param [DramaQueen::Exchange] exchange
    def initialize(exchange)
      @exchange = exchange
      @subscribers = []
    end

    # @return [Array<DramaQueen::Topic>]
    def related_topics
      @exchange.related_keys.map do |topic_key|
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
  end
end
