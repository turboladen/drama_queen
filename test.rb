require './lib/drama_queen/publisher'

class A
  include DramaQueen::Publisher

  def do_stuff
    publish 'stuff', "I'm doing the stuff"
  end
end


require './lib/drama_queen/subscriber'

class B
  include DramaQueen::Subscriber

  def initialize
    1000000.times do
    #100.times do
      subscribe 'stuff', :call_me
    end
  end

  def call_me(msg)
    #puts "I got called!"
    #puts msg
  end
end

a = A.new
b = B.new

a.do_stuff
