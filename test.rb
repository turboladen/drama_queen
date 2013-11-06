require './lib/drama_queen/publisher'

class A
  include DramaQueen::Publisher

  def do_stuff
    publish 'stuff1', "I'm doing the stuff111111111"
    publish 'stuff2', "I'm doing the stuff222222222"
    publish 'stuff5', "I'm doing the stuff555555555"
    publish 'stuff3', "I'm doing the stuff333333333"
    publish 'stuff5', "I'm doing the stuff555555555"
  end
end


require './lib/drama_queen/subscriber'

class B
  include DramaQueen::Subscriber

  def initialize
    100000.times do
      subscribe 'stuff1', :call_me
      subscribe 'stuff2', :call_me2
      subscribe 'stuff3', :call_me
      subscribe 'stuff4', :call_me2
      subscribe 'stuff5', ->(arg) {
        #puts arg
      }
    end
  end

  def call_me(msg)
    #puts msg
  end

  def call_me2(msg)
    #puts msg
  end
end

a = A.new
b = B.new

a.do_stuff
