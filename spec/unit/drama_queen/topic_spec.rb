require 'spec_helper'
require 'drama_queen/topic'


describe DramaQueen::Topic do
  let(:object) { Object.new }

  describe '#related_topic_keys' do
    let(:topics) do
      ['one', object, 'things.stuff', 'things.stuff.pants', 'things.meow.pants']
    end

    before do
      allow(DramaQueen).to receive(:routing_keys) { topics }
    end

    context '*' do
      subject { described_class.new('*') }

      it 'returns all Topics' do
        expect(subject.related_topic_keys).to eq [
          'one', object, 'things.stuff', 'things.stuff.pants', 'things.meow.pants']
      end
    end

    context 'an object' do
      subject { described_class.new(object) }

      it 'returns the object' do
        expect(subject.related_topic_keys).to eq [object]
      end
    end

    context 'things.*' do
      subject { described_class.new('things.*') }

      it 'returns all Topics' do
        expect(subject.related_topic_keys).to eq %w[things.stuff]
      end
    end

    context 'things.*.pants' do
      subject { described_class.new('things.*.pants') }

      it 'returns all Topics' do
        expect(subject.related_topic_keys).to eq %w[things.stuff.pants things.meow.pants]
      end
    end
  end

  describe '#related_topics' do
    let(:topic1) { double 'DramaQueen::Topic1' }
    let(:topic2) { double 'DramaQueen::Topic2' }
    let(:topic3) { double 'DramaQueen::Topic3' }

    before do
      DramaQueen.instance_variable_set(:@subscriptions, {
        'one' => topic1,
        object => topic2,
        'things.stuff' => topic3
      })
    end

    context '*' do
      subject { described_class.new('*') }

      it 'returns all Topics' do
        expect(subject.related_topics).to eq [topic1, topic2, topic3]
      end
    end

    context 'things.*' do
      subject { described_class.new('things.*') }

      it 'returns all Topics' do
        expect(subject.related_topics).to eq [topic3]
      end
    end
  end

  describe '#notify_with' do
    subject do
      described_class.new 'test_topic'
    end

    context 'list is empty' do
      it 'does not raise an error' do
        expect { subject.notify_with('stuff') }.to_not raise_exception
      end
    end

    context 'list is not empty' do
      it 'it #calls each subscriber with the given args' do
        subscriber = double 'Subscriber'
        subject.instance_variable_set(:@subscribers, [subscriber])
        expect(subscriber).to receive('call').with(1, 2, 3)

        subject.notify_with 1, 2, 3
      end
    end
  end
end
