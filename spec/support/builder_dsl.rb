# Sugar to build a complicated tree more easily.
module BuilderDSL
  attr_writer :first_child, :next_sibling

  def self.included(base)
    base.extend(ClassMethods)
  end

  def node(&block)
    new_node = append_child
    new_node.instance_eval(&block) if block_given?
  end

  def append_child
    if !first_child
      self.first_child = Node.new
    else
      first_child.append_sibling
    end
  end

  def append_sibling
    if !next_sibling
      self.next_sibling = Node.new
    else
      last_sibling.next_sibling = Node.new
    end
  end

  def last_sibling
    sib = next_sibling
    while sib.next_sibling
      sib = sib.next_sibling
    end
    sib
  end

  def last_child
    first_child.last_sibling
  end

  module ClassMethods
    def build(&block)
      root = Node.new
      root.instance_eval(&block)
      root
    end
  end
end
