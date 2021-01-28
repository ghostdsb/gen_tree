defmodule GenTree do
  @moduledoc """
  Documentation for `GenTree`.
  Tree data structure for BEAM in BEAM-way. Each node is a process that contains data and children_pids (just like using pointers).
  """

  @spec new(any) :: pid
  @doc """
  New node of GenTree

  ## Examples

      iex> root = GenTree.new(5)
      iex> is_pid(root) === true

  """
  def new(data), do: GenTree.Node.new(data)


  @spec get_node(pid) :: GenTree.Node.t
  @doc """
  Get the node details %GenTree.Node{children: children_list, data: any(), left: pid()\\:nil, right: pid()\\nil}

  ## Examples

      iex> root = GenTree.new(5)
      iex> root |> GenTree.get_node()
      %GenTree.Node{children: [], data: 5, left: nil, right: nil}

  """
  def get_node(node_pid), do: GenTree.Node.get_node(node_pid)

  @spec get_data(pid) :: any
  @doc """
  Get the node data value %GenTree.Node{children: children_list, data: any(), left: pid()\\:nil, right: pid()\\nil}

  ## Examples

      iex> root = GenTree.new(5)
      iex> root |> GenTree.get_data()
      5

  """
  def get_data(node_pid), do: GenTree.Node.get_data(node_pid)

  @spec get_left(pid) :: pid
  @doc """
  Get the left child of node

  ## Examples
      iex> root = GenTree.new(5)
      iex> left_child = GenTree.get_left(root)

  """
  def get_left(node_pid), do: GenTree.Node.get_left(node_pid)

  @spec get_right(pid ) :: pid
  @doc """
  Get the right child of node

  ## Examples
      iex> root = GenTree.new(5)
      iex> right_child = GenTree.get_right(root)

  """
  def get_right(node_pid), do: GenTree.Node.get_right(node_pid)

  @spec left?(pid ) :: boolean()
  @doc """
  Return if data has a left child

   ## Examples
      iex> root = GenTree.new(5)
      iex> GenTree.left?(root)
      false

  """
  def left?(node_pid), do: GenTree.Node.left?(node_pid)

  @spec right?(pid ) :: boolean()
  @doc """
  Return if data has a right child

   ## Examples
      iex> root = GenTree.new(5)
      iex> GenTree.right?(root)
      false

  """
  def right?(node_pid), do: GenTree.Node.right?(node_pid)

  @spec update_data(pid , any) :: :ok
  @doc """
  Updates the data value of the node
  """
  def update_data(node_pid, data), do: GenTree.Node.update_data(node_pid, data)

  @spec update_node(pid , any) :: :ok
  @doc """
  Updates complete node value
  """
  def update_node(node_pid, data), do: GenTree.Node.update_node(node_pid, data)

  @doc """
  Inserts child to the node and returns the child pid.
  child_type can be :left, :right or omitted.

  ## Examples

      iex(21)> root = GenTree.new("a")
      iex(23)> left_child = GenTree.insert_child(root, "b", :left)
      iex(25)> GenTree.get_node(left_child)
      %GenTree.Node{children: [], data: "b", left: nil, right: nil}
  """
  def insert_child(node_pid, data, child_type \\ :nil), do: GenTree.Node.insert_child(node_pid, data, child_type)

  @doc """
  Builds a Binary tree from a list of data

  ## Examples

      iex(85)> root = GenTree.build_tree([1,2,3,4,5])
      iex(86)> rl = GenTree.get_left(root)
      iex(87)> rlr = GenTree.get_right(rl)
      iex(87)> GenTree.get_data(rlr)
      5

  """
  def build_tree(data_list), do: GenTree.Builder.build_tree_level_order(data_list)

  @spec dfs(pid, :inorder | :postorder | :preorder ) :: [any]
  @doc """

  Traverses a binary tree using DFS.
  Traversal types
    * :inorder
    * :preorder
    * :postorder

  ## Examples

      iex> root = GenTree.build_tree([1,2,3,4,5,6])
      iex> GenTree.Traversal.dfs(root, :inorder)
      [4, 2, 5, 1, 6, 3]
      iex> GenTree.Traversal.dfs(root, :preorder)
      [1, 2, 4, 5, 3, 6]
      iex> GenTree.Traversal.dfs(root, :postorder)
      [4, 5, 2, 6, 3, 1]

  """
  def dfs(parent_pid, traversal_type), do: GenTree.Traversal.dfs(parent_pid, traversal_type)

  @spec bfs(pid) :: [any]
  @doc """
  Traverses a binary tree using BFS.

  ## Examples

      iex> root = GenTree.build_tree([1,2,3,4,5,6])
      iex> GenTree.Traversal.bfs(root)
      [1, 2, 3, 4, 5, 6]

  """
  def bfs(parent_pid), do: GenTree.Traversal.bfs(parent_pid)


end
