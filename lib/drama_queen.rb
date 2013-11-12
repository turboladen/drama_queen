require_relative 'drama_queen/version'


# This is the singleton that holds all topics and subscriptions.
module DramaQueen

  # The list of all subscriptions that DramaQueen knows about.  This is updated
  # by DramaQueen::Consumers as they subscribe to topics.
  #
  # @return [Array<DramaQueen::Exchange>]
  def self.exchanges
    @exchanges ||= Array.new
  end

  # Finds the DramaQueen::Exchange for the given +routing_key+.
  #
  # @param [Object] routing_key
  # @return [DramaQueen::Exchange]
  def self.exchange_for(routing_key)
    exchanges.find do |exchange|
      exchange.routing_key == routing_key
    end
  end

  # @param [Object] routing_key
  # @return [Boolean]
  def self.routes_to?(routing_key)
    !!exchange_for(routing_key)
  end

  # Removes all subscribers from the subscribers list.
  #
  # @return [Array]
  def self.unsubscribe_all
    @exchanges = Array.new
  end
end
