class Node
  include Comparable
  attr_accessor :data, :left, :right
  def <=>(other)
    unless other == nil
      data <=> other.data
    else
      data <=> other
    end
  end
  
  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :rootB
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array, s=nil, e=nil)
    if s == nil
      sorted = array.uniq.sort
      return build_tree(sorted, 0, sorted.length - 1)
    elsif s > e
      return nil
    else
      mid = (s+e)/2
      node = Node.new(array[mid]);
      node.left = build_tree(array, s, mid-1)
      node.right = build_tree(array, mid+1, e)
      return node
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(key, root = @root)
    if root == nil
      root = Node.new(key)
      return root
    elsif key < root.data
      root.left = insert(key, root.left)
    elsif key > root.data
      root.right = insert(key, root.right)
    end
    return root
  end

  def delete(key, root = @root)
    if root == nil
      return root
    elsif key < root.data
      root.left = delete(key, root.left)
    elsif key > root.data
      root.right = delete(key, root.right)
    else
      if root.left == nil
        return root.right
      elsif root.right == nil
        return root.left
      else
        succParent = root
        succ = root.right
        while succ.left != nil
          succParent = succ
          succ = succ.left
        end
        if succParent != root
          succParent.left = succ.right
        else
          succParent.right = succ.right
        end
        root.data = succ.data
      end
    end
    return root
  end

  def find(key, root = @root)
    if root == nil || root.data == key
      return root
    elsif root.data < key
      return find(key, root.right)
    else
      return find(key, root.left)
    end
  end

  def level_order
    queue = []
    val = []
    unless @root == nil
      queue << @root
      while queue.length > 0
        node = queue.shift
        yield(node) if block_given?
        val << node.data
        queue << node.left if node.left != nil
        queue << node.right if node.right != nil
      end
    end
    val
  end

  def in_order(node = @root, nodes = [], val = [])
    if node == nil
      return
    else
      in_order(node.left, nodes, val)
      nodes << node
      val << node.data
      in_order(node.right, nodes, val)
    end
    if block_given?
      for node in nodes
        yield(node)
      end
    end
    val
  end

  def pre_order(node = @root, nodes = [], val = [])
    if node == nil
      return
    else
      nodes << node
      val << node.data
      pre_order(node.left, nodes, val)
      pre_order(node.right, nodes, val)
    end
    if block_given?
      for node in nodes
        yield(node)
      end
    end
    val
  end

  def post_order(node = @root, nodes = [], val = [])
    if node == nil
      return
    else
      post_order(node.left, nodes, val)
      post_order(node.right, nodes, val)
      nodes << node
      val << node.data
    end
    if block_given?
      for node in nodes
        yield(node)
      end
    end
    val
  end

  def height(node)
    if node == nil
      return -1
    else
      return [height(node.left), height(node.right)].max + 1
    end
  end

  def depth(node, root = @root)
    if root == nil
      return -1
    end
    dist = -1
    if (root == node || (dist = depth(node, root.left)) >= 0 || (dist = depth(node, root.right)) >= 0)
      return dist + 1;
    end
    return dist
  end

  def balanced?(root = @root)
    if root == nil
      return true
    else
      if (height(root.left) - height(root.right)).abs > 1
        return false
      else
        return balanced?(root.left) && balanced?(root.right)
      end
    end
  end

  def rebalance
    @root = build_tree(self.in_order)
  end
end

t = Tree.new(Array.new(15) { rand(1..100) })
t.balanced?
t.level_order
t.pre_order
t.post_order
t.in_order
t.insert(1000);nil
t.insert(1001);nil
t.insert(1002);nil
t.balanced?
t.rebalance;nil
t.balanced?
t.level_order
t.pre_order
t.post_order
t.in_order