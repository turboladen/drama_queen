require 'spec_helper'
require 'drama_queen/consumer'


describe DramaQueen::Consumer do
  subject do
    Object.new.extend(DramaQueen::Consumer)
  end

  describe '#subscribe with a Symbol callback' do
    it 'adds itself to the list of subscribers' do
      callback = double 'Method', call: true

      subject.should_receive(:method).with(:call_me) { callback }
      subject.subscribe('test', :call_me)

      expect(DramaQueen.subscribers.size).to eq 1
      expect(DramaQueen.subscribers['test']).to eq [callback]
    end
  end
end
