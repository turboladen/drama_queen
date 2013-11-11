module DramaQueen
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
