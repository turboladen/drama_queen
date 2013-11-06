module DramaQueen
  class SubscriberGroup < Array
    def notify_with(*args)
      self.each do |subscriber|
        subscriber.call(*args)
      end
    end
  end
end
