class Node
  attr_reader :first_child, :next_sibling

  def initialize(first_child = nil, next_sibling = nil)
    @first_child = first_child
    @next_sibling = next_sibling
  end

  def count_descendants
    return 0 if leaf?
    all_children.size + extended_family_size
  rescue SystemStackError => e
    fail CircularDependencyDetected, e
  end

  protected

  # All remaining siblings of this node.
  def siblings
    return [] if next_sibling.nil?
    [next_sibling] + next_sibling.siblings
  end

  private

  def all_children
    return [] if leaf?
    @all_children ||= [first_child] + first_child.siblings
  end

  def leaf?
    first_child.nil?
  end

  def extended_family_size
    all_children.map(&:count_descendants).inject(:+)
  end

  class CircularDependencyDetected < RuntimeError; end
end
