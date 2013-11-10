require 'spec_helper'
require 'drama_queen/routing_key'


describe DramaQueen::RoutingKey do
  let(:key_object) { Object.new }
  let(:key_all) { '**' }
  let(:key_all_root) { '*' }
  let(:key_root) { 'root' }
  let(:key_notroot) { 'not-root' }
  let(:key_root_and_tree) { 'root.**' }
  let(:key_root_and_children) { 'root.*' }
  let(:key_root_child1) { 'root.child1' }
  let(:key_root_child2) { 'root.child2' }
  let(:key_root_child1_and_children) { 'root.child1.*' }
  let(:key_root_child2_and_children) { 'root.child2.*' }
  let(:key_root_child2_and_grandchild) { 'root.child2.grandchild' }
  let(:key_root_child2_and_greatgrandchild) { 'root.child2.grandchild.great_grandchild' }
  let(:key_root_child3_and_grandchild) { 'root.child3.grandchild' }
  let(:key_root_all_children_with_grandchild) { 'root.*.grandchild' }

  let(:routing_keys) do
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
    allow(DramaQueen).to receive(:routing_keys) { routing_keys }
  end

  describe '#routes_to?' do
    context '**' do
      subject { described_class.new(key_all) }

      it 'returns true for all keys' do
        routing_keys.all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq true
        end
      end
    end

    context '*' do
      subject { described_class.new(key_all_root) }
      let(:true_keys) do
        routing_keys - false_keys
      end

      let(:false_keys) do
        routing_keys - [key_all_root, key_root, key_notroot]
      end

      it 'returns true to all root level keys' do
        true_keys.all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq true
        end
      end

      it 'returns false to all root level keys' do
        false_keys.all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq false
        end
      end
    end

    context 'an object' do
      subject { described_class.new(key_object) }
      specify { expect(subject.routes_to?(key_object)).to eq true }

      it 'returns false to all other keys' do
        (routing_keys - [key_object]).all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq false
        end
      end
    end

    context 'root' do
      subject { described_class.new(key_root) }
      specify { expect(subject.routes_to?(key_root)).to eq true }

      it 'returns false to all other keys' do
        (routing_keys - [key_root]).all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq false
        end
      end
    end

    context 'not-root' do
      subject { described_class.new(key_notroot) }
      specify { expect(subject.routes_to?(key_notroot)).to eq true }

      it 'returns false to all other keys' do
        (routing_keys - [key_notroot]).all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq false
        end
      end
    end

    context 'root.**' do
      subject { described_class.new(key_root_and_tree) }

      let(:true_keys) do
        routing_keys - false_keys
      end

      let(:false_keys) do
        routing_keys - [key_root_and_tree,
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

      it 'returns true to all descendants keys of root' do
        true_keys.all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq true
        end
      end

      it 'returns false to all non-descendants keys of root' do
        false_keys.all? do |routing_key|
          expect(subject.routes_to?(routing_key)).to eq false
        end
      end
    end
  end

  describe '#routes' do
    context '**' do
      subject { described_class.new(key_all) }

      it 'returns all keys' do
        expect(subject.routes).to eq routing_keys
      end
    end

    context '*' do
      subject { described_class.new(key_all_root) }

      it 'returns all root level keys' do
        expect(subject.routes).to eq [
          key_all_root, key_root, key_notroot
        ]
      end
    end

    context 'an object' do
      subject { described_class.new(key_object) }
      specify { expect(subject.routes).to eq [key_object] }
    end

    context 'root' do
      subject { described_class.new(key_root) }
      specify { expect(subject.routes).to eq [key_root] }
    end

    context 'not-root' do
      subject { described_class.new(key_notroot) }
      specify { expect(subject.routes).to eq [key_notroot] }
    end

    context 'root.**' do
      subject { described_class.new(key_root_and_tree) }
      specify do
        expect(subject.routes).to eq [
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
    end

    context 'root.*' do
      subject { described_class.new(key_root_and_children) }
      specify do
        expect(subject.routes).to eq [key_root_and_children, key_root_child1, key_root_child2]
      end
    end

    context 'root.child1' do
      subject { described_class.new(key_root_child1) }
      specify { expect(subject.routes).to eq [key_root_child1] }
    end

    context 'root.child2' do
      subject { described_class.new(key_root_child2) }
      specify { expect(subject.routes).to eq [key_root_child2] }
    end

    context 'root.child1.*' do
      subject { described_class.new(key_root_child1_and_children) }
      specify { expect(subject.routes).to eq [key_root_child1_and_children] }
    end

    context 'root.child2.*' do
      subject { described_class.new(key_root_child2_and_children) }
      specify { expect(subject.routes).to eq [key_root_child2_and_children, key_root_child2_and_grandchild] }
    end

    context 'root.child2.grandchild' do
      subject { described_class.new(key_root_child2_and_grandchild) }
      specify { expect(subject.routes).to eq [key_root_child2_and_grandchild] }
    end

    context 'root.child2.grandchild.great_grandchild' do
      subject { described_class.new(key_root_child2_and_greatgrandchild) }
      specify { expect(subject.routes).to eq [key_root_child2_and_greatgrandchild] }
    end

    context 'root.child3.grandchild' do
      subject { described_class.new(key_root_child3_and_grandchild) }
      specify { expect(subject.routes).to eq [key_root_child3_and_grandchild] }
    end

    context 'root.*.grandchild' do
      subject { described_class.new(key_root_all_children_with_grandchild) }
      specify do
        expect(subject.routes).to eq [
          key_root_child2_and_grandchild,
          key_root_child3_and_grandchild,
          key_root_all_children_with_grandchild
        ]
      end
    end
  end
end
