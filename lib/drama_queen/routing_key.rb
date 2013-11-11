module DramaQueen

  # A RoutingKey determines which objects will receive messages from a Producer.
  # It is merely a wrapper around the +primitive+ that is given on
  # initialization, allowing to more easily determine which routes are related,
  # and thus if any subscribers to the related routes should get notified in
  # addition to the subscribers to this route.
  #
  # A RoutingKey primitive is what Producers and Consumers refer to when they're
  # looking to publish or subscribe.  The RoutingKey primitive can be any
  # object, but some extra semantics & functionality come along if you use
  # DramaQueen's simple hierarchy model.
  #
  # First, the simplest case: a primitive that is any Ruby object.  Producers
  # and Subscribers will use this case when pub/sub-ing on that Ruby object.  No
  # related RoutingKeys will matched; all messages published to this RoutingKey
  # will only get delivered to consumers subscribing to this RoutingKey
  # primitive.  If you're only needing this approach, you might be better off
  # just using Ruby's build-in +Observer+ library--it accomplishes this, and is
  # much simpler than DramaQueen.
  #
  # Now, the fun stuff: RoutingKey globbing.  Using this approach lets you tie
  # together other RoutingKeys, via +#related_keys+, thus letting you build
  # some organization/structure into your whole system of routing messages.
  # These globs (somewhat similar to using +Dir.glob+ for file systems) let your
  # producers and consumers pub/sub to large numbers of topics, yet organize
  # those topics.  The structure that you build is up to you.  Here's a contrived
  # example.  You could use keys like:
  #
  #   * 'my_library.bob.pants'
  #   * 'my_library.bob.shirts'
  #   * 'my_library.sally.pants'
  #   * 'my_library.sally.shirts'
  #
  # When producers publish to 'my_library.bob.pants', only consumers of
  # 'my_library.bob.pants' get notified.  If a producer publishes to
  # 'my_library.*.pants', consumers of both 'my_library.bob.pants' _and_
  # 'my_library.sally.pants' get notifications.  Going the other way, if
  # a consumer subscribes to 'my_library.*.pants', then when a producer on
  # 'my_library.bob.pants', _or_ 'my_library.sally.pants', or
  # 'my_library.*.pants', that consumer gets all of those messages.
  #
  # Further, producers and consumers can use a single asterisk at multiple
  # levels: '*.*.shirts' would resolve to both 'my_library.bob.shirts' and
  # 'my_library.sally.shirts'; if there was a 'someone_else.vendor.shirts', that
  # would route as well.
  #
  # Lastly, you can you a double-asterisk to denote that you want everything
  # from that level and deeper.  So, '**' would match all existing routing keys,
  # including single-object (non-glob style) keys.  'my_library.**' would match
  # all four of our 'my_library' keys.
  #
  # As you're devising your routing key scheme, consider naming like you would
  # name classes/modules in a Ruby library: use namespaces to avoid messing
  # others up!  Notice the use of 'my_library...' above... that was on purpose.
  class RoutingKey
    attr_reader :primitive

    # @param [Object] primitive
    def initialize(primitive)
      @primitive = primitive
    end

    # @param [Object] routing_key
    # @return [Boolean]
    def routes_to?(routing_key)
      related_keys.include? routing_key
    end

    # @return [Array<DramaQueen::RoutingKey]
    def related_keys
      return DramaQueen.routing_keys if self.primitive == '**'

      DramaQueen.routing_keys.find_all do |routing_key|
        next if routing_key.primitive == '**'
        next if routing_key.primitive == self.primitive

        if self.primitive.is_a?(String) && routing_key.primitive.is_a?(String)

          primitive_match?(routing_key.primitive, self.primitive) ||
            primitive_match?(self.primitive, routing_key.primitive)
        else
          routing_key == self
        end
      end
    end

    private

    # @return [Boolean]
    def primitive_match?(first, second)
      self_matcher = make_matchable(second)

      !!first.match(Regexp.new(self_matcher))
    end

    # @param [String] string
    # @return [String]
    def make_matchable(string)
      matcher = if string =~ %r[\*\*]
        string.sub(%r[\.?\*\*], '\..+')
      elsif string =~ %r[\*]
        string.sub(%r[\*], '[^\.]+')
      else
        string
      end

      matcher = matcher.gsub('.*', '\.\w+')
      matcher = "\\A#{matcher}\\z"

      matcher
    end
  end
end
