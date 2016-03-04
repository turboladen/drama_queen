require_relative 'drama_queen/version'


# This is the singleton that maintains the list of active exchanges.
module DramaQueen

  # All known consumers.  These consumers may or may not be actively
  # participating in an exchange; they've simply just been defined as consumer.
  #
  # @return [Array<Object>]
  def self.consumers
    @consumers ||= Array.new
  end

  # The list of all exchanges that DramaQueen knows about.  This is updated
  # by DramaQueen::Consumers as they subscribe to topics.
  #
  # @return [Array{String => DramaQueen::Exchange}]
  def self.exchanges
    @exchanges ||= Hash.new
  end

  # All known producers.  These producers may or may not be actively
  # participating in an exchange; they've simply just ben defined as a
  # producer.
  #
  # @return [Array<Object>]
  def self.producers
    @producers ||= Array.new
  end

  # @param [Object] routing_key
  # @return [Boolean]
  def self.routes_to?(routing_key)
    exchanges.has_key? routing_key
  end

  # All known subscribers.  Subscribers are consumers that are actively
  # participating in an exchange.
  #
  # @return [Array<Object>]
  def self.subscribers
    exchanges.map do |_, exchange|
      exchange.subscribers
    end
  end

  # Removes all exchanges from the exchanges list.
  #
  # @return [Array]
  def self.unsubscribe_all
    @exchanges = {}
  end
end
