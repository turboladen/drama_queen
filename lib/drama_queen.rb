require_relative 'drama_queen/version'


# This is the singleton that holds all topics and subscriptions.
module DramaQueen

  # The list of all subscriptions that DramaQueen knows about.  This is updated
  # by DramaQueen::Consumers as they subscribe to topics.
  #
  # @return [Hash{Object => DramaQueen::Topic}]
  def self.subscriptions
    @subscriptions ||= {}
  end

  # @return [Array]
  def self.exchanges
    subscriptions.keys
  end

  # Finds the DramaQueen::Exchange for the given +routing_key+.
  #
  # @param [Object] routing_key
  # @return [DramaQueen::Exchange]
  def self.exchange_by_routing_key(routing_key)
    exchanges.find do |exchange|
      exchange.routing_key == routing_key
    end
  end

  # @param [Object] routing_key
  # @return [Boolean]
  def self.routes_to?(routing_key)
    !!exchange_by_routing_key(routing_key)
  end

  # @return [Array]
  def self.topics
    subscriptions.values
  end

  # Removes all subscribers from the subscribers list.
  #
  # @return [Hash]
  def self.unsubscribe_all
    @subscriptions = {}
  end
end
