require_relative '../drama_queen'
require_relative 'exchange'


module DramaQueen

  # A +producer+ is an object that has content to provide on a +topic+.  When
  # it decides it has content to +publish+ on that topic, it simply passes that
  # info on to all of the +consumer+s that have +subscribe+d to the topic.
  # Actually, it doesn't have to pass any info on--it can simply act like a ping
  # to the subscribers; this is up to how you want to use them.
  module Producer

    # @param routing_key
    # @param args
    # @return [Boolean] +true+ if anything was published; +false+ if not.
    def publish(routing_key, *args)
      exchange = DramaQueen.exchange_for(routing_key)
      exchange ||= DramaQueen::Exchange.new(routing_key)

      all_exchanges = [exchange] + exchange.related_exchanges
      subscription_count = 0

      all_exchanges.each do |exchange|
        subscription_count += exchange.subscribers.size
        exchange.notify_with(*args)
      end

      !subscription_count.zero?
    end
  end
end
