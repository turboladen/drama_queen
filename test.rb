=begin
require './lib/drama_queen/producer'
require './lib/drama_queen/consumer'

class A
  include DramaQueen::Consumer

  def initialize
    subscribe 'root.*.children', :call_me
  end

  def call_me(*args)
    puts "A got called with args: #{args}"
  end
end

class B
  include DramaQueen::Producer

  def do_stuff
    publish 'root.parent', 1, 2, 3
  end
end

class C
  include DramaQueen::Producer

  def do_stuff
    publish 'root.parent.children', 1, 2, 3
  end
end


a = A.new
b = B.new
c = C.new

puts 'B...'
b.do_stuff
puts 'C...'
c.do_stuff
=end

=begin
require './lib/drama_queen/producer'

class A
  include DramaQueen::Producer

  def do_stuff
    criteria = -> { true }
    publish criteria, "I'm doing the stuff111111111"
  end
end


require './lib/drama_queen/consumer'

class B
  include DramaQueen::Consumer

  def initialize
    criteria = -> { true }
    subscribe criteria, :call_me
  end

  def call_me(msg)
    puts msg
  end
end

a = A.new
b = B.new

a.do_stuff
=end


def routes? first, second
  first_minus_second = first - second
  second_minus_first = second - first
  puts "first: #{first}"
  puts "second: #{second}"
  puts "first minus second: #{first - second}"
  puts "second minus first: #{second - first}"
  puts "first size: #{first.size}"
  puts "second size: #{second.size}"

  puts 'first loop'
  first.each_cons(second.size) { |e| p e }
  puts 'second loop'
  second.each_cons(first.size) { |e| p e }

  if first == second
    true
  elsif (first_minus_second).uniq == %w[*] && first.size == second.size
    true
  elsif first_minus_second.all? { |e| e =~ Regexp.new(second_minus_first.join('.'))}
    true
=begin
  elsif (second_minus_first).size == (first_minus_second).size &&
    first.size == second.size &&
    first_minus_second =~ second_minus_first
    true
=end
  else
    false
  end
end

a = %w[root parent child]
b = %w[root * child]
c = %w[root parent meow]
d = %w[root parent *]
e = %w[root * child *]
f = %w[root parent child thing]

puts '-' * 40
puts '-' * 40
puts 'A' * 40
puts "a should route to a: #{routes? a, a}"
puts '-' * 40

puts "a should route to b: #{routes? a, b}"
puts '-' * 40

puts "a should NOT route to c: #{routes? a, c}"
puts '-' * 40

puts "a should route to d: #{routes? a, d}"
puts '-' * 40

puts "a should NOT route to e: #{routes? a, e}"
puts '-' * 40

puts "a should NOT route to f: #{routes? a, f}"
puts '-' * 40

=begin
puts '-' * 40
puts '-' * 40
puts 'B' * 40
puts "b should route to a: #{routes? b, a}"
puts '-' * 40

puts "b should route to b: #{routes? b, b}"
puts '-' * 40

puts "b should NOT route to c: #{routes? b, c}"
puts '-' * 40

puts "b should route to d: #{routes? b, d}"
puts '-' * 40

puts "b should NOT route to e: #{routes? b, e}"
puts '-' * 40

puts "b should NOT route to f: #{routes? b, f}"
puts '-' * 40

puts "c should NOT route to a: #{routes? c, a}"
puts '-' * 40
=end
