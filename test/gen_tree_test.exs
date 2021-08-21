defmodule GenTreeTest do
  use ExUnit.Case
  doctest GenTree

  test "new tree" do
    root_node = GenTree.new(1)

    assert is_pid(root_node)
  end

  test "get a node by node pid" do
    root_node = GenTree.new(5)

    assert GenTree.get_node(root_node) === %GenTree.Node{
      children: [], data: 5, left: nil, right: nil, parent: nil
    }
  end

  test "get node data" do
    root_node = GenTree.new(5)

    assert GenTree.get_data(root_node) === 5
  end

  test "insert child" do
    root_node = GenTree.new(5)

    left_child = GenTree.insert_child(root_node, 1, :left)
    right_child = GenTree.insert_child(root_node, 2, :right)

    assert GenTree.get_data(left_child) === 1
    assert GenTree.get_data(right_child) === 2
  end

  test "count children" do
    root_node = GenTree.new(5)

    _left_child = GenTree.insert_child(root_node, 1, :left)
    _right_child = GenTree.insert_child(root_node, 2, :right)

    assert GenTree.count_children(root_node) === 2
  end

  test "update node data" do
    root_node = GenTree.new(5)

    left_child = GenTree.insert_child(root_node, 1, :left)
    right_child = GenTree.insert_child(root_node, 2, :right)

    assert GenTree.get_data(left_child) === 1
    assert GenTree.get_data(right_child) === 2

    GenTree.update_data(left_child, 3)
    GenTree.update_data(right_child, 4)

    assert GenTree.get_data(left_child) === 3
    assert GenTree.get_data(right_child) === 4
  end

  test "build a tree from list" do
    root_node = GenTree.from_list([1,2,3,4,5,nil,6])
    root_left_child = GenTree.get_left(root_node)
    root_right_child = GenTree.get_right(root_node)

    assert GenTree.count_children(root_left_child) === 2
    assert GenTree.count_children(root_right_child) === 1
  end

  test "bfs traversal" do
    root_node = GenTree.from_list([1,2,3,4,5,6])

    assert GenTree.Traversal.bfs(root_node) === [1,2,3,4,5,6]
  end

  test "dfs traversal" do
    root_node = GenTree.from_list([1,2,3,4,5,6])

    assert GenTree.Traversal.dfs(root_node, :inorder) === [4, 2, 5, 1, 6, 3]
    assert GenTree.Traversal.dfs(root_node, :preorder) === [1,2,4,5,3,6]
    assert GenTree.Traversal.dfs(root_node, :postorder) === [4, 5, 2, 6, 3, 1]
  end

end
