# GenTree

Tree data structure for BEAM in BEAM-way

1. Start a new tree
    ```elixir
    iex> GenTree.new(5)
    #PID<0.172.0>
    ```

2. Get node data
    ```elixir
    iex> root_pid = GenTree.new(5)
    #PID<0.172.0>
    iex> root_pid |> GenTree.get_node()
    %GenTree.Node{children: [], data: 5, left: nil, right: nil}
    ```

3. Get left or right child
    ```elixir
    iex> GenTree.get_node(root)
    %GenTree.Node{
      children: [#PID<0.221.0>, #PID<0.216.0>],
      data: 1,
      left: #PID<0.216.0>,
      right: #PID<0.221.0>
    }
    iex> GenTree.get_left(root)
    #PID<0.216.0>
    iex> GenTree.get_right(root)
    #PID<0.221.0>
    ```
4. If node has a left or right child
    ```elixir
    iex> GenTree.get_node(root)
    %GenTree.Node{
      children: [#PID<0.221.0>, #PID<0.216.0>],
      data: 1,
      left: #PID<0.216.0>,
      right: #PID<0.221.0>
    }
    iex> GenTree.left?(root)
    true
    ```

5. Inserting a child to parent in left, right or omitted for general n-ary
    ```elixir
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
    ```
