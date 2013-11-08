module DramaQueen

  # A SubscriberGroup is simply a collection of subscribers.  You probably don't
  # need to use this explicitly; this is what DramaQueen::Producer uses to
  # notify subscribers.
  class SubscriberGroup < Array
    def notify_with(*args)
      self.each do |subscriber|
        subscriber.call(*args)
      end
    end
  end
end
