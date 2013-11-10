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

  def self.topic_keys
    subscriptions.keys
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
