require_relative '../drama_queen'
require_relative 'routing_key'


module DramaQueen

  # A +producer+ is an object that has content to provide on a +topic+.  When
  # it decides it has content to +publish+ on that topic, it simply passes that
  # info on to all of the +consumer+s that have +subscribe+d to the topic.
  # Actually, it doesn't have to pass any info on--it can simply act like a ping
  # to the subscribers; this is up to how you want to use them.
  module Producer

    # @param routing_key_primitive
    # @param args
    def publish(routing_key_primitive, *args)
      routing_key = DramaQueen.routing_key_by_primitive(routing_key_primitive)
      routing_key ||= DramaQueen::RoutingKey.new(routing_key_primitive)

      related_topics = routing_key.related_keys.map do |related_route|
        DramaQueen.subscriptions[related_route]
      end

      return false if related_topics.empty?

      related_topics.each do |topic|
        topic.notify_with(*args)
      end

      true
    end
  end
end
