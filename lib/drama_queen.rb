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

  def self.exchanges
    subscriptions.keys
  end

  def self.routing_key_by_primitive(routing_key_primitive)
    exchanges.find do |routing_key|
      routing_key.routing_key == routing_key_primitive
    end
  end

  def self.routes_to?(routing_key_query)
    !!routing_key_by_primitive(routing_key_query)
  end

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
