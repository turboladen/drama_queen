require_relative '../drama_queen'
require_relative 'exchange'


module DramaQueen

  # A +consumer+ is simply an object that receives messages from a +producer+.
  # In order to sign up to receive messages from a producer, the consumer
  # subscribes to a +topic+ that they're interested in.  When the producer
  # +publish+es something on that topic, the consumer's +callback+ will get
  # called.
  module Consumer
    def self.included(base)
      DramaQueen.consumers << base
    end

    # @return [Array<DramaQueen::Exchange>]
    def exchanges
      routing_keys.map do |routing_key|
        DramaQueen.exchanges[routing_key]
      end
    end

    # @param [Object] routing_key The routing key that represents the Exchange
    #   to subscribe to.
    # @param [Symbol,Method,Proc] callback If given a Symbol, this will be
    #   converted to a Method that gets called on the includer of Consumer.  If
    #   +callback+ is not a Symbol, it simply must just respond to +call+.
    def subscribe(routing_key, callback)
      callable_callback = callback.is_a?(Symbol) ? method(callback) : callback

      unless callable_callback.respond_to?(:call)
        raise "The given callback is not a Symbol, nor responds to #call: #{callback}"
      end

      routing_keys << routing_key

      exchange = if DramaQueen.routes_to? routing_key
        DramaQueen.exchanges[routing_key]
      else
        Exchange.new(routing_key)
      end

      exchange.subscribers << callable_callback
    end

    # Removes consumer from the exchange defined by +routing_key+.
    #
    # @param routing_key [String,Object]
    # @return [Boolean]
    def unsubscribe(routing_key)
      return false unless DramaQueen.exchanges.has_key? routing_key

      DramaQueen.exchanges[routing_key].unsubscribe(self)
    end

    # Removes consumer from all exchanges it's subscribed to.
    #
    # @return [Boolean] +true+ if unsubscribed from any exchanges; +false+ if
    #   not.
    def unsubscribe_all
      return false if routing_keys.length.zero?

      did_unsubscribe = routing_keys.map do |routing_key|
        unsubscribe(routing_key) && routing_keys.delete(routing_key)
      end

      did_unsubscribe.all?
    end

    private

    def routing_keys
      @routing_keys ||= Array.new
    end
  end
end
