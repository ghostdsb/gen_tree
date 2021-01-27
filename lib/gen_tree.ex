defmodule GenTree do
  @moduledoc """
  Documentation for `GenTree`.
  """

  @doc """
  New node of GenTree

  ## Examples

      iex> GenTree.new(5)
      #PID<0.172.0>

  """
  def new(data), do: GenTree.Node.new(data)


  @doc """
  Get the node details %GenTree.Node{children: children_list, data: any(), left: pid()\\:nil, right: pid()\\nil}

  ## Examples

      iex> root_pid = GenTree.new(5)
      #PID<0.172.0>
      iex> root_pid |> GenTree.get_node()
      %GenTree.Node{children: [], data: 5, left: nil, right: nil}

  """
  def get_node(node_pid), do: GenTree.Node.get_node(node_pid)

  @doc """
  Get the left child of node

  ## Examples

      iex> GenTree.get_node(root)
      %GenTree.Node{
        children: [#PID<0.221.0>, #PID<0.216.0>],
        data: 1,
        left: #PID<0.216.0>,
        right: #PID<0.221.0>
      }
      iex> GenTree.get_left(root)
      #PID<0.216.0>

  """
  def get_left(node_pid), do: GenTree.Node.get_left(node_pid)

  @doc """
  Get the right child of node

  ## Examples

      iex> GenTree.get_node(root)
      %GenTree.Node{
        children: [#PID<0.221.0>, #PID<0.216.0>],
        data: 1,
        left: #PID<0.216.0>,
        right: #PID<0.221.0>
      }
      iex> GenTree.get_right(root)
      #PID<0.221.0>

  """
  def get_right(node_pid), do: GenTree.Node.get_right(node_pid)

  @doc """
  Return if data has a left child

   ## Examples

      iex> GenTree.get_node(root)
      %GenTree.Node{
        children: [#PID<0.221.0>, #PID<0.216.0>],
        data: 1,
        left: #PID<0.216.0>,
        right: #PID<0.221.0>
      }
      iex> GenTree.left?(root)
      true

  """
  def left?(node_pid), do: GenTree.Node.left?(node_pid)

  @doc """
  Return if data has a right child

   ## Examples

      iex> GenTree.get_node(root)
      %GenTree.Node{
        children: [#PID<0.216.0>],
        data: 1,
        left: #PID<0.216.0>,
        right: nil
      }
      iex> GenTree.right?(root)
      false

  """
  def right?(node_pid), do: GenTree.Node.right?(node_pid)

  @doc """
  Updates the data value of the node
  """
  def update_data(node_pid, data), do: GenTree.Node.update_data(node_pid, data)

  @doc """
  Updates complete node value
  """
  def update_node(node_pid, data), do: GenTree.Node.update_node(node_pid, data)

  @doc """
  Inserts child to the node and returns the child pid.
  child_type can be :left, :right or omitted.

  ## Examples

      iex(21)> root = GenTree.new("a")
      #PID<0.228.0>

      iex(22)> GenTree.get_node(root)
      %GenTree.Node{children: [], data: "a", left: nil, right: nil}

      iex(23)> left_child = GenTree.insert_child(root, "b", :left)
      #PID<0.231.0>

      iex(24)> GenTree.get_node(root)
      %GenTree.Node{
        children: [#PID<0.231.0>],
        data: "a",
        left: #PID<0.231.0>,
        right: nil
      }

      iex(25)> GenTree.get_node(left_child)
      %GenTree.Node{children: [], data: "b", left: nil, right: nil}
  """
  def insert_child(node_pid, data, child_type \\ :nil), do: GenTree.Node.insert_child(node_pid, data, child_type)

  @doc """

  Builds a Binary tree from a list of data

  ## Examples

      iex(85)> root = GenTree.build_tree([1,2,3,4,5])
      #PID<0.398.0>
      iex(86)> rl = GenTree.get_left(root)
      #PID<0.399.0>
      iex(87)> rlr = GenTree.get_right(rl)
      #PID<0.402.0>
      iex(88)> GenTree.get_node(rlr)
      %GenTree.Node{children: [], data: 5, left: nil, right: nil}
      iex(89)> GenTree.get_node(rl)
      %GenTree.Node{
        children: [#PID<0.402.0>, #PID<0.401.0>],
        data: 2,
        left: #PID<0.401.0>,
        right: #PID<0.402.0>
      }

  """
  def build_tree(data_list), do: GenTree.BinaryTree.build_tree_level_order(data_list)


end
