defmodule GenTree do
    @moduledoc """
    Tree data structure for BEAM in BEAM-way. Each node is a process that contains data and children_pids. The pid is used as pointers.

    Tree implementation becomes straight forwards with pointers that can point to a node and a shared state that helps in while performing operations on different nodes, say traversals.
    A work around this would be using ```Agents```.

        Agents are a simple abstraction around state.

        Often in Elixir there is a need to share or store state that must be accessed
        from different processes or by the same process at different points in time.

        The Agent module provides a basic server implementation that allows state to be
        retrieved and updated via a simple API.

    Thus a node in tree can be described as

    ```elixir
    {:ok, node_pid} = Agent.start(fn -> %{data: "some_data"} end)
    ```
    This provides us with a pid which can be used to point to the node and a state that can be manipulated.
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
  Get the node details.

  ## Examples

      iex> root = GenTree.new(5)
      iex> root |> GenTree.get_node()
      %GenTree.Node{children: [], data: 5, left: nil, right: nil, parent: nil}

  """
  def get_node(node_pid), do: GenTree.Node.get_node(node_pid)

  @spec get_data(pid) :: any
  @doc """
  Get the node data value.

  ## Examples

      iex> root = GenTree.new(5)
      iex> root |> GenTree.get_data()
      5

  """
  def get_data(node_pid), do: GenTree.Node.get_data(node_pid)

  @spec get_left(pid) :: pid | nil
  @doc """
  Get the left child of node in case of binary tree [:nary, 2]

  ## Examples
      iex> root = GenTree.new(5)
      iex> GenTree.get_left(root)

  """
  def get_left(node_pid), do: GenTree.Node.get_left(node_pid)

  @spec get_right(pid ) :: pid | nil
  @doc """
  Get the right child of node in case of binary tree [:nary, 2]

  ## Examples
      iex> root = GenTree.new(5)
      iex> GenTree.get_right(root)

  """
  def get_right(node_pid), do: GenTree.Node.get_right(node_pid)

  @spec get_children(pid) :: [pid]
  @doc """
  Get the children list of the node

  """
  def get_children(node_pid), do: GenTree.Node.get_children(node_pid)

  @spec count_children(pid) :: number()
  @doc """
  Counts the number of children of the node

  ## Examples
      iex> root = GenTree.new(5)
      iex> GenTree.count_children(root)
      0
      iex> GenTree.insert_child(root, "b", :left)
      iex> GenTree.insert_child(root, "a", :right)
      iex> GenTree.count_children(root)
      2

  """
  def count_children(node_pid), do: GenTree.Node.count_children(node_pid)

  @spec has_left?(pid) :: boolean()
  @doc """
  Return if data has a left child in case of binary tree [:nary, 2]

   ## Examples
      iex> root = GenTree.new(5)
      iex> GenTree.has_left?(root)
      false

  """
  def has_left?(node_pid), do: GenTree.Node.has_left?(node_pid)

  @spec has_right?(pid ) :: boolean()
  @doc """
  Return if data has a right child in case of binary tree [:nary, 2]

   ## Examples
      iex> root = GenTree.new(5)
      iex> GenTree.has_right?(root)
      false

  """
  def has_right?(node_pid), do: GenTree.Node.has_right?(node_pid)

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

  @spec set_parent(pid , pid) :: :ok
  @doc """
  Updates the parent pid of node.
  """
  def set_parent(self_pid, parent_pid), do: GenTree.Node.set_parent(self_pid, parent_pid)

  @spec get_parent(pid) :: pid
  @doc """
  Updates the parent pid of node.
  """
  def get_parent(self_pid), do: GenTree.Node.get_parent(self_pid)

  @doc """
  Inserts child to the node and returns the child pid.
  child_type can be :left, :right or omitted.

  ## Examples

      iex(21)> root = GenTree.new("a")
      iex(23)> left_child = GenTree.insert_child(root, "b", :left)
      iex(25)> GenTree.get_parent(left_child) === root
      true
  """
  def insert_child(node_pid, data, child_type \\ :nil), do: GenTree.Node.insert_child(node_pid, data, child_type)

  @doc """
  Builds a tree from a datalist in level-order. Data can have ```nil``` to skip sub-tree.
  """
  def from_list(data_list, opts \\ [nary: 2]), do: GenTree.Builder.from_list(data_list, opts)

  @spec dfs(pid, :inorder | :preorder | :postorder) :: [any]
  @doc """

  Traverses a binary tree using DFS.

  Traversal types
    * :inorder
    * :preorder
    * :postorder

  ## Examples

      iex> root = GenTree.from_list([1,2,3,4,5,6])
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
  Traverses a tree using BFS.

  ## Examples

      iex> root = GenTree.from_list([1,2,3,4,5,6])
      iex> GenTree.Traversal.bfs(root)
      [1, 2, 3, 4, 5, 6]

  """
  def bfs(parent_pid), do: GenTree.Traversal.bfs(parent_pid)

  @spec reduce(pid, any, (any(), any() -> any()), keyword) :: any
  @doc """
  Invokes reducer_function for each node_pid in the tree with the accumulator.

  Default tree traversal method is Breadth-First-Search and default order of Depth First Search is postorder. Traversal options can be passed as Keyword list as

        [
            search: :bfs | :dfs,
            order: :postorder, :preorder, :inorder
        ]

  ## Examples

      iex> root = GenTree.from_list([1,2,3,nil,4,5,7,nil,nil,8,9])
      iex> GenTree.reduce(root, 0, fn node_pid, acc -> acc + GenTree.get_data(node_pid) end)
      39
      iex> GenTree.reduce(root, [], fn node_pid, acc -> acc ++ [GenTree.get_data(node_pid)] end, [search: :dfs, order: :postorder])
      [4, 2, 8, 9, 5, 7, 3, 1]
      iex> GenTree.dfs(root, :postorder)
      [4, 2, 8, 9, 5, 7, 3, 1]
      iex> GenTree.reduce(root, [], fn node_pid, acc -> acc ++ [node_pid] end, [search: :dfs, order: :postorder]) |>
      ...> Enum.map(fn node_pid -> GenTree.get_data(node_pid) end)
      [4, 2, 8, 9, 5, 7, 3, 1]

  """
  def reduce(root_pid, initial_value, reducer_function, traverse_opts \\ [search: :bfs]) do
    search_method = Keyword.get(traverse_opts, :search)
    order =  Keyword.get(traverse_opts, :order, :postorder)

    case search_method do
        :bfs -> GenTree.Traversal.bfs(root_pid, initial_value, reducer_function)
        :dfs -> GenTree.Traversal.dfs(root_pid, order, initial_value, reducer_function)
    end
  end

end
