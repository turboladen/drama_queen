require_relative 'spec_helper'
require 'drama_queen'


describe DramaQueen do
  describe '.subscribers' do
    it 'is created as an empty Hash' do
      DramaQueen.subscribers.must_be_instance_of Hash
    end
  end
end
