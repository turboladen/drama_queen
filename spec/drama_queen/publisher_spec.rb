require_relative '../spec_helper'
require 'drama_queen/publisher'


describe DramaQueen::Publisher do
  subject do
    Object.new.extend(DramaQueen::Publisher)
  end

  describe '#publish with no subscribers' do
    it 'returns nil' do
      subject.publish('test').must_equal nil
    end
  end
end
