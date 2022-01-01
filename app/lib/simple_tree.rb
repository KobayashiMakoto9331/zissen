class SimpleTree
  attr_reader :root, :nodes
  def initialize(root, decendants)
    @root = root
    @decendants = decendants

    @nodes = {}
    ([@root] + @decendants).each do |d|
      d.child_nodes = []
      @nodes[d.id] = d
    end

    @decendants.each do |d|
      @nodes[d.parent_id].child_nodes << @nodes[d.id]
    end
  end
end
