require_relative '../drama_queen'
require_relative 'exchange'


module DramaQueen

  # A +consumer+ is simply an object that receives messages from a +producer+.
  # In order to sign up to receive messages from a producer, the consumer
  # subscribes to a +topic+ that they're interested in.  When the producer
  # +publish+es something on that topic, the consumer's +callback+ will get
  # called.
  module Consumer

    # @param routing_key The route or object to subscribe to.
    # @param [Symbol,Method,Proc] callback If given a Symbol, this will be
    #   converted to a Method that gets called on the includer of Consumer.  If
    #   +callback+ is not a Symbol, it simply must just respond to +call+.
    def subscribe(routing_key, callback)
      callable_callback = callback.is_a?(Symbol) ? method(callback) : callback

      unless callable_callback.respond_to?(:call)
        raise "The given callback is not a Symbol, nor responds to #call: #{callback}"
      end

      unless DramaQueen.routes_to? routing_key
        add_topic_for(routing_key)
      end

      routing_key = DramaQueen.exchange_by_routing_key(routing_key)

      DramaQueen.subscriptions[routing_key].subscribers << callable_callback
    end

    private

    def add_topic_for(routing_key)
      exchange = Exchange.new(routing_key)
      topic = Topic.new(exchange)
      DramaQueen.subscriptions[exchange] = topic
    end
  end
end

require_relative 'topic'
