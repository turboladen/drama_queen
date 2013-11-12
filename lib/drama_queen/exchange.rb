module DramaQueen

  # An Exchange determines which objects will receive messages from a Producer.
  # It is merely a wrapper around the +routing_key+ that is given on
  # initialization, allowing to more easily determine which routing_keys are related,
  # and thus if any subscribers to the related exchanges should get notified in
  # addition to the subscribers to this exchange.
  #
  # A Exchange routing_key is what Producers and Consumers refer to when they're
  # looking to publish or subscribe.  The Exchange +routing_key+ can be any
  # object, but some extra semantics & functionality come along if you use
  # DramaQueen's route_key globbing.
  #
  # === Ruby Objects
  #
  # First, the simplest case: a routing_key that is any Ruby object.  Producers
  # and subscribers will use this case when pub/sub-ing on that Ruby object.  No
  # related routing_keys will match; all messages published using this routing_key
  # will only get delivered to consumers subscribing to this Exchange's
  # routing_key.  If you only need this approach, you might be better off just
  # using Ruby's build-in +Observer+ library--it accomplishes this, and is much
  # simpler than DramaQueen.
  #
  # === RouteKey Globbing
  #
  # Now, the fun stuff: routing_key globbing uses period-delimited strings to
  # infer some hierarchy of Exchanges.  Using this approach lets you tie
  # together other Exchanges via +#related_keys+, thus letting you build
  # some organization/structure into your whole system of routing messages.
  # These globs (somewhat similar to using +Dir.glob+ for file systems) let your
  # producers and consumers pub/sub to large numbers of topics, yet organize
  # those topics.  The structure that you build is up to you.  Here's a
  # contrived example.  You could use key routing_key like:
  #
  # * +"my_library.bob.pants"+
  # * +"my_library.bob.shirts"+
  # * +"my_library.sally.pants"+
  # * +"my_library.sally.shirts"+
  #
  # When producers publish to +"my_library.bob.pants"+, only consumers of
  # +"my_library.bob.pants"+ get notified.  If a producer publishes to
  # +"my_library.*.pants"+, consumers of both +"my_library.bob.pants"+ _and_
  # +"my_library.sally.pants"+ get notifications.  Going the other way, if
  # a consumer subscribes to +"my_library.*.pants"+, then when a producer on
  # +"my_library.bob.pants"+, _or_ +"my_library.sally.pants"+, _or_
  # +"my_library.*.pants"+, that consumer gets all of those messages.
  #
  # Further, producers and consumers can use a single asterisk at multiple
  # levels: +"\*.\*.shirts"+ would resolve to both +"my_library.bob.shirts"+ and
  # +"my_library.sally.shirts"+; if there was a +"someone_else.vendor.shirts"+,
  # for example, that would route as well.
  #
  # Lastly, you can you a double-asterisk to denote that you want everything
  # from that level and deeper.  So, +"**"+ would match _all_ existing routing
  # keys, including single-object (non-glob style) keys.  +"my_library.**"+
  # would match all four of our +"my_library"+ keys.
  #
  # As you're devising your routing key scheme, consider naming like you would
  # name classes/modules in a Ruby library: use namespaces to avoid messing
  # others up!  Notice the use of +"my_library..."+ above... that was on purpose.
  class Exchange
    attr_reader :routing_key

    # @return [Array]
    attr_reader :subscribers

    # @param [Object] routing_key
    def initialize(routing_key)
      @routing_key = routing_key
      @subscribers = []
    end

    # @param [Object] routing_key
    # @return [Boolean]
    def routes_to?(routing_key)
      related_exchanges.include? routing_key
    end

    # @return [Array<DramaQueen::Exchange]
    def related_exchanges
      return DramaQueen.exchanges if self.routing_key == '**'

      DramaQueen.exchanges.find_all do |exchange|
        next if exchange.routing_key == '**'
        next if exchange.routing_key == self.routing_key

        if self.routing_key.is_a?(String) && exchange.routing_key.is_a?(String)
          routing_key_match?(exchange.routing_key, self.routing_key) ||
            routing_key_match?(self.routing_key, exchange.routing_key)
        else
          exchange == self
        end
      end
    end

    # Calls each subscriber's callback with the given arguments.
    #
    # @param args
    def notify_with(*args)
      @subscribers.each do |subscriber|
        subscriber.call(*args)
      end
    end

    private

    # @return [Boolean]
    def routing_key_match?(first, second)
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
