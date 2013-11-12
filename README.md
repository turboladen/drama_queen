# DramaQueen

A simple, synchronous pub-sub/observer library that allows objects to observe or
publish and subscribe to topics.

[![Build Status](https://travis-ci.org/turboladen/drama_queen.png?branch=master)](https://travis-ci.org/turboladen/drama_queen)

## Features

* Observe Ruby objects and receive updates when they change
  ([Observer Pattern](http://en.wikipedia.org/wiki/Observer_pattern))
* Subscribe and publish on a topic or routing key
  ([Publish-Subscribe Pattern](http://en.wikipedia.org/wiki/Publish–subscribe_pattern))
* Synchronous, no threading


## Usage

My initial desire for this library was to replace Ruby's built-in Observer
module with something that allowed objects to observe specific topics, as
opposed to simply just observing objects.  DramaQueen lets you do both.

### Subscribe to an object

```ruby
class MyProducer
  include DramaQueen::Producer

  def do_stuff
    publish(self, "I did some stuff!", [1, 2, 3])
  end
end

class MyConsumer
  include DramaQueen::Consumer

  def initialize(topic)
    subscribe(topic, :call_me!)
  end

  def call_me!(message, neat_array)
    puts "He did it! -> #{message}"
    puts "A present for me?!  #{neat_array}"
  end
end

producer = MyProducer.new
consumer = MyConsumer.new(producer)
producer.do_stuff

# "He did it! -> I did some stuff!"
# "A present for me?!  [1, 2, 3]"
#=> true
```

`consumer` subscribes to the `producer` object and `producer` publishes on the
topic of itself, thus publishing to `consumer`.  Also notice that the consumer
passed in `:call_me!` as the second parameter to `#subscribe`: that registers
the `#call_me!` method to be called when the producer publishes.  We can see
that when we call `producer.do_stuff`, `consumer.call_me!` gets called by
the strings that get output to the console.  Also notice that `consumer.call_me!`
gets the same parameters passed to it that are passed in to `producer`'s call
to `#publish`.


### Subscribe to a topic

Subscribing to a topic is no different than subscribing to an object.

```ruby
class ThingsProducer
  include DramaQueen::Producer

  def do_stuff
    publish('things', "I did some stuff!", [1, 2, 3])
  end
end

class ThingsConsumer
  include DramaQueen::Consumer

  def initialize(topic)
    subscribe(topic, :call_me!)
  end

  def call_me!(message, neat_array)
    puts "He did it! -> #{message}"
    puts "A present for me?!  #{neat_array}"
  end
end

producer = ThingsProducer.new
consumer = ThingsConsumer.new('things')
producer.do_stuff

# "He did it! -> I did some stuff!"
# "A present for me?!  [1, 2, 3]"
#=> true
```

Moral of the story: The topic that you publish/subscribe on can be any Ruby
object--how you use this is up to you.

### Routing Key Matching

Thus far, we've talked about subscribing to a "topic".

```ruby
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

b.do_stuff

# (A does not get called)
c.do_stuff
# "A got called with args: 1, 2, 3
#=> true
```

See {DramaQueen::Exchange} for more.

### Synchronous Only!

DramaQueen does not use any threading or fancy asynchronous stuff.  When your
producer publishes, you can expect your subscribers to receive the notifications:

* in the order the publishing was triggered, and
* in the order that consumers subscribed.

This is intentional.  If you want publishing to take place in a thread, you can
thread your call to #publish in your code.

### Application-wide

DramaQueen stores all of its exchanges in a singleton, which is thus accessible
throughout your app/library.  This makes it possible to subscribe to a topic in
one object and publish to that topic in another unrelated object from anywhere
in your code.  And while you have access to `DramaQueen`, you shouldn't ever
need to deal with it directly--just use `#publish` and `#subscribe` and let it
do its thing.


## Installation

Add this line to your application's Gemfile:

    gem 'drama_queen'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drama_queen


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
