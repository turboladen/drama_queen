require 'spec_helper'
require 'drama_queen/exchange'


describe DramaQueen::Exchange do
  let(:prim_object) { Object.new }
  let(:prim_all) { '**' }
  let(:prim_all_root) { '*' }
  let(:prim_root) { 'root' }
  let(:prim_notroot) { 'not-root' }
  let(:prim_root_and_tree) { 'root.**' }
  let(:prim_root_and_children) { 'root.*' }
  let(:prim_root_child1) { 'root.child1' }
  let(:prim_root_child2) { 'root.child2' }
  let(:prim_root_child1_and_children) { 'root.child1.*' }
  let(:prim_root_child2_and_children) { 'root.child2.*' }
  let(:prim_root_child2_and_grandchild) { 'root.child2.grandchild' }
  let(:prim_root_child2_and_greatgrandchild) { 'root.child2.grandchild.great_grandchild' }
  let(:prim_root_child3_and_grandchild) { 'root.child3.grandchild' }
  let(:prim_root_all_children_with_grandchild) { 'root.*.grandchild' }

  let(:key_object) { described_class.new(prim_object) }
  let(:key_all) { described_class.new '**' }
  let(:key_all_root) { described_class.new '*' }
  let(:key_root) { described_class.new 'root' }
  let(:key_notroot) { described_class.new 'not-root' }
  let(:key_root_and_tree) { described_class.new 'root.**' }
  let(:key_root_and_children) { described_class.new 'root.*' }
  let(:key_root_child1) { described_class.new 'root.child1' }
  let(:key_root_child2) { described_class.new 'root.child2' }
  let(:key_root_child1_and_children) { described_class.new 'root.child1.*' }
  let(:key_root_child2_and_children) { described_class.new 'root.child2.*' }
  let(:key_root_child2_and_grandchild) { described_class.new 'root.child2.grandchild' }
  let(:key_root_child2_and_greatgrandchild) { described_class.new 'root.child2.grandchild.great_grandchild' }
  let(:key_root_child3_and_grandchild) { described_class.new 'root.child3.grandchild' }
  let(:key_root_all_children_with_grandchild) { described_class.new 'root.*.grandchild' }

  let(:exchanges) do
    [
      key_object,
      key_all,
      key_all_root,
      key_root,
      key_notroot,
      key_root_and_tree,
      key_root_and_children,
      key_root_child1,
      key_root_child2,
      key_root_child1_and_children,
      key_root_child2_and_children,
      key_root_child2_and_grandchild,
      key_root_child2_and_greatgrandchild,
      key_root_child3_and_grandchild,
      key_root_all_children_with_grandchild
    ]
  end

  before do
    allow(DramaQueen).to receive(:exchanges) { exchanges }
  end

  describe '#related_keys' do
    context '**' do
      subject { described_class.new(prim_all) }

      it 'returns all keys' do
        expect(subject.related_exchanges).to eq exchanges
      end
    end

    context '*' do
      subject { described_class.new(prim_all_root) }

      it 'returns all root level keys' do
        expect(subject.related_exchanges).to eq [
          key_root,
          key_notroot
        ]
      end
    end

    context 'an object' do
      subject { described_class.new(prim_object) }

      specify do
        expect(subject.related_exchanges).to eq []
      end
    end

    context 'root' do
      subject { described_class.new(prim_root) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_all_root
        ]
      end
    end

    context 'not-root' do
      subject { described_class.new(prim_notroot) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_all_root,
        ]
      end
    end

    context 'root.**' do
      subject { described_class.new(prim_root_and_tree) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_children,
          key_root_child1,
          key_root_child2,
          key_root_child1_and_children,
          key_root_child2_and_children,
          key_root_child2_and_grandchild,
          key_root_child2_and_greatgrandchild,
          key_root_child3_and_grandchild,
          key_root_all_children_with_grandchild
        ]
      end
    end

    context 'root.*' do
      subject { described_class.new(prim_root_and_children) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
          key_root_child1,
          key_root_child2
        ]
      end
    end

    context 'root.child1' do
      subject { described_class.new(prim_root_child1) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
          key_root_and_children,
        ]
      end
    end

    context 'root.child2' do
      subject { described_class.new(prim_root_child2) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
          key_root_and_children,
        ]
      end
    end

    context 'root.child1.*' do
      subject { described_class.new(prim_root_child1_and_children) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
        ]
      end
    end

    context 'root.child2.*' do
      subject { described_class.new(prim_root_child2_and_children) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
          key_root_child2_and_grandchild
        ]
      end
    end

    context 'root.child2.grandchild' do
      subject { described_class.new(prim_root_child2_and_grandchild) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
          key_root_child2_and_children,
          key_root_all_children_with_grandchild
        ]
      end
    end

    context 'root.child2.grandchild.great_grandchild' do
      subject { described_class.new(prim_root_child2_and_greatgrandchild) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
        ]
      end
    end

    context 'root.child3.grandchild' do
      subject { described_class.new(prim_root_child3_and_grandchild) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
          key_root_all_children_with_grandchild
        ]
      end
    end

    context 'root.*.grandchild' do
      subject { described_class.new(prim_root_all_children_with_grandchild) }

      specify do
        expect(subject.related_exchanges).to eq [
          key_root_and_tree,
          key_root_child2_and_grandchild,
          key_root_child3_and_grandchild,
        ]
      end
    end
  end

  describe '#notify_with' do
    let(:object) { Object.new }

    subject do
      described_class.new 'test_key'
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
