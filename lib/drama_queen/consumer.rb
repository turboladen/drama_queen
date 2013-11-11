require_relative '../drama_queen'
require_relative 'routing_key'


module DramaQueen

  # A +consumer+ is simply an object that receives messages from a +producer+.
  # In order to sign up to receive messages from a producer, the consumer
  # subscribes to a +topic+ that they're interested in.  When the producer
  # +publish+es something on that topic, the consumer's +callback+ will get
  # called.
  module Consumer

    # @param routing_key_primitive The route or object to subscribe to.
    # @param [Symbol,Method,Proc] callback If given a Symbol, this will be
    #   converted to a Method that gets called on the includer of Consumer.  If
    #   +callback+ is not a Symbol, it simply must just respond to +call+.
    def subscribe(routing_key_primitive, callback)
      callable_callback = callback.is_a?(Symbol) ? method(callback) : callback

      unless callable_callback.respond_to?(:call)
        raise "The given callback is not a Symbol, nor responds to #call: #{callback}"
      end

      unless DramaQueen.routes_to? routing_key_primitive
        add_topic_for(routing_key_primitive)
      end

      routing_key = DramaQueen.routing_key_by_primitive(routing_key_primitive)

      DramaQueen.subscriptions[routing_key].subscribers << callable_callback
    end

    private

    def add_topic_for(routing_key_primitive)
      routing_key = RoutingKey.new(routing_key_primitive)
      topic = Topic.new(routing_key)
      DramaQueen.subscriptions[routing_key] = topic
    end
  end
end

require_relative 'topic'
