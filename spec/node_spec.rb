require 'spec_helper'

describe Node do
  before { Node.send :include, BuilderDSL }

  describe '#count_descendants' do
    context 'on a terminal node' do
      subject { Node.new }
      it 'is zero' do
        expect(subject.count_descendants).to be_zero
      end
    end

    context 'when the considered node has siblings' do
      subject { Node.new(nil, Node.new) }
      it 'they are ignored' do
        expect(subject.count_descendants).to be_zero
      end
    end

    context 'with a single child' do
      subject { Node.new(Node.new) }
      it 'is one' do
        expect(subject.count_descendants).to eq(1)
      end
    end

    context 'with a complex tree' do
      subject {
        Node.build {
          node
          node {
            node
            node {
              node
            }
            node
          }
          node
          node
        }
      }
      it 'counts correctly' do
        expect(subject.count_descendants).to eq(8)
      end

      context 'circular reference checking' do
        it 'handles sibling loops' do
          tree.last_child.next_sibling = tree.first_child
          expect{ tree.count_descendants }.to raise_error(Node::CircularDependencyDetected)
        end

        it 'handles child loops' do
          tree.first_child.first_child = tree.first_child
          expect{ tree.count_descendants }.to raise_error(Node::CircularDependencyDetected)
        end
      end
    end
  end
end
