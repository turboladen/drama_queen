module DramaQueen
  class RoutingKey
    attr_reader :original

    def initialize(original)
      @original = original
    end

    def routes_to?(routing_key)
      routes.include? routing_key
    end

    def routes
      return DramaQueen.routing_keys if self.original == '**'

      DramaQueen.routing_keys.find_all do |routing_key|
        if self.original.is_a?(String) && routing_key.is_a?(String)
          self_matcher = make_matchable(self.original)

          routing_key == self.original ||
            routing_key.match(Regexp.new(self_matcher))
        else
          routing_key == self.original
        end
      end
    end

    private

    def make_matchable(string)
      matcher = if string =~ %r[\*\*]
        string.sub(%r[\.?\*\*], '\..+')
      elsif string =~ %r[\*]
        string.sub(%r[\*], '[^\.|**]+')
      else
        string
      end

      matcher = matcher.gsub('.*', '\.\w+')
      matcher = "\\A#{matcher}\\z"

      matcher
    end
  end
end
