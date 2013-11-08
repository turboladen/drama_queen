require_relative 'drama_queen/version'


# This is the singleton that holds all topics and subscriptions.
module DramaQueen

  # The list of all subscriptions that DramaQueen knows about.  This is updated
  # by DramaQueen::Consumers as they subscribe to topics.
  #
  # @return [Hash{Object => DramaQueen::SubscriberGroup}]
  def self.subscribers
    @subscribers ||= {}
  end

  # Removes all subscribers from the subscribers list.
  #
  # @return [Hash]
  def self.unsubscribe_all
    @subscribers = {}
  end
end
