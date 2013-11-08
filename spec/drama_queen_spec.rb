require 'spec_helper'
require 'drama_queen'


describe DramaQueen do
  describe '.subscribers' do
    it 'is created as an empty Hash' do
      expect(DramaQueen.subscribers).to be_an_instance_of Hash
    end
  end
end
