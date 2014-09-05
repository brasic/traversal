require File.join(File.dirname(__FILE__), '../lib/node')

describe Node do
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
        Node.new(
          Node.new(
            Node.new(nil,
              Node.new(nil,
                Node.new
              )
            ),
            Node.new(Node.new,
              Node.new(
                Node.new
              )
            )
          )
        )
      }
      it 'counts correctly' do
        expect(subject.count_descendants).to eq(8)
      end
    end
  end
end
