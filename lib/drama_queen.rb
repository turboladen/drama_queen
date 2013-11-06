require_relative 'drama_queen/version'


module DramaQueen
  def self.subscribers
    @subscribers ||= {}
  end
end
