defmodule GenTree.Traversal do
  @moduledoc false

  @spec bfs(pid, any, (any(), any() -> any())) :: any
  def bfs(root_node_pid, initial_value \\ [],  reducer_function \\ fn x, acc -> acc ++ [x |> GenTree.get_data()] end) do
    q = :queue.new()
    q = :queue.in(root_node_pid, q)
    {:ok, agent_pid} = Agent.start(fn -> initial_value end)
    bfs_h(q, agent_pid, reducer_function)
  end

  defp bfs_h(queue, agent_pid, reducer_function) do
    cond do
      :queue.is_empty(queue) ->
        Agent.get(agent_pid, fn traversed_node_pids -> traversed_node_pids end)
      true ->
        {{:value, node_pid}, queue} = :queue.out(queue)
        Agent.update(agent_pid, fn traversed_node_pids -> reducer_function.(node_pid, traversed_node_pids) end)

        queue =
          node_pid
          |> GenTree.get_children()
          |> Enum.reverse()
          |> Enum.reduce(queue, fn child_pid, queue -> :queue.in(child_pid, queue) end)

        bfs_h(queue, agent_pid, reducer_function)
    end
  end

  @spec dfs(pid, :postorder|:inorder|:preorder, any, (any(), any() -> any())) :: any
  def dfs(root_node_pid, traversal_type, initial_value \\ [],  reducer_function \\ fn x, acc -> acc ++ [x |> GenTree.get_data()] end) do
    stack = [root_node_pid]
    {:ok, agent_pid} = Agent.start(fn -> initial_value end)
    visit_map = %{root_node_pid => true}
    dfs( stack, agent_pid, traversal_type, visit_map, reducer_function)
  end

  defp dfs([], agent_pid, _traversal_type, _visit_map, _reducer_function), do: Agent.get(agent_pid, fn traversal_data -> traversal_data end)

  defp dfs([node_pid| _rest_stack] = stack, agent_pid, traversal_type, visit_map, reducer_function) do
   left_child = GenTree.get_left(node_pid)
   right_child = GenTree.get_right(node_pid)

   {operation, [_head| rest] = stack, visit_map} = push_children(left_child, right_child, stack, visit_map, traversal_type)

   case operation do
    :pop ->
      Agent.update(agent_pid, fn traversal_data -> reducer_function.(node_pid, traversal_data) end)
      dfs(rest, agent_pid, traversal_type, visit_map, reducer_function)
    :continue ->
      dfs(stack, agent_pid, traversal_type, visit_map, reducer_function)
   end

  end

  ## postorder traversal
  defp push_children(left_child, right_child, stack, visit_map, traversal_type)
  defp push_children(nil, nil, stack, visit_map, :postorder), do: {:pop, stack, visit_map}
  defp push_children(nil, right_child, stack, visit_map, :postorder) do
    cond do
      Map.has_key?(visit_map, right_child) ->
        {:pop, stack, visit_map}
      true ->
        {:continue, [right_child |stack], Map.put(visit_map, right_child, true)}
    end
  end
  defp push_children(left_child, nil, stack, visit_map, :postorder) do
    cond do
      Map.has_key?(visit_map, left_child) ->
        {:pop, stack, visit_map}
      true ->
        {:continue, [left_child |stack], Map.put(visit_map, left_child, true)}
    end
  end
  defp push_children(left_child, right_child, stack, visit_map, :postorder) do
    cond do
      Map.has_key?(visit_map, left_child) && Map.has_key?(visit_map, right_child) ->
        {:pop, stack, visit_map}
      Map.has_key?(visit_map, left_child) && not Map.has_key?(visit_map, right_child) ->
        {:continue, [right_child |stack], Map.put(visit_map, right_child, true)}
      not Map.has_key?(visit_map, left_child) && Map.has_key?(visit_map, right_child) ->
        {:continue, [left_child |stack], Map.put(visit_map, left_child, true)}
      true ->
        {:continue, [left_child, right_child |stack], Map.put(visit_map, right_child, true) |> Map.put(left_child, true)}
    end
  end

  ## inorder traversal
  defp push_children(nil, nil, stack, visit_map, :inorder), do: {:pop, stack, visit_map}
  defp push_children(left_child, nil, stack, visit_map, :inorder) do
    cond do
      Map.has_key?(visit_map, left_child) ->
        {:pop, stack, visit_map}
      true ->
        {:continue, [left_child |stack], Map.put(visit_map, left_child, true)}
    end
  end
  defp push_children(nil, right_child, [_head_node| rest_stack] = _stack, visit_map, :inorder) do
    {:pop, [nil, right_child | rest_stack], visit_map}
  end
  defp push_children(left_child, right_child, [head| rest_stack] = stack, visit_map, :inorder) do
    cond do
      not Map.has_key?(visit_map, left_child) && not Map.has_key?(visit_map, right_child) ->
        {:continue, [left_child, head, right_child |rest_stack], Map.put(visit_map, right_child, true) |> Map.put(left_child, true)}
      true ->
        {:pop, stack, visit_map}
    end
  end

  ## preorder traversal
  defp push_children(nil, nil, [_head| rest] = _stack, visit_map, :preorder) do
    {:pop, [nil| rest], visit_map}
  end
  defp push_children(nil, right_child, [_head| rest] = _stack, visit_map, :preorder) do
    {:pop, [nil, right_child | rest], visit_map}
  end
  defp push_children(left_child, nil, [_head| rest] = _stack, visit_map, :preorder) do
    {:pop, [nil, left_child | rest], visit_map}
  end
  defp push_children(left_child, right_child, [_head| rest] = _stack, visit_map, :preorder) do
    {:pop, [nil, left_child, right_child | rest], visit_map}
  end
end
