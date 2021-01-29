defmodule GenTree.Traversal do
  @moduledoc false

  @spec dfs(pid, :inorder | :postorder | :preorder) :: [any]
  def dfs(root_node_pid, opt) do
    {:ok, agent_pid} = Agent.start(fn -> [] end)

    root_node_pid
    |> dfs(agent_pid, opt)

    Agent.get(agent_pid, fn traversal_data -> traversal_data end)
  end

  defp dfs(node_pid, agent_pid, :inorder) do
    cond do
      is_nil(node_pid) ->
        :ok
      true ->
        node_pid
        |> GenTree.Node.get_left()
        |> dfs(agent_pid, :inorder)

        node_data = node_pid |> GenTree.Node.get_data()
        Agent.update(agent_pid, fn traversal_data -> traversal_data ++ [node_data] end)

        node_pid
        |> GenTree.Node.get_right()
        |> dfs(agent_pid, :inorder)
    end
  end

  defp dfs(node_pid, agent_pid, :preorder) do
    cond do
      is_nil(node_pid) ->
        :ok
      true ->
        node_data = node_pid |> GenTree.Node.get_data()
        Agent.update(agent_pid, fn traversal_data -> traversal_data ++ [node_data] end)

        node_pid
        |> GenTree.Node.get_left()
        |> dfs(agent_pid, :preorder)


        node_pid
        |> GenTree.Node.get_right()
        |> dfs(agent_pid, :preorder)
    end
  end

  defp dfs(node_pid, agent_pid, :postorder) do
    cond do
      is_nil(node_pid) ->
        :ok
      true ->
        node_pid
        |> GenTree.Node.get_left()
        |> dfs(agent_pid, :postorder)

        node_pid
        |> GenTree.Node.get_right()
        |> dfs(agent_pid, :postorder)

        node_data = node_pid |> GenTree.Node.get_data()
        Agent.update(agent_pid, fn traversal_data -> traversal_data ++ [node_data] end)
    end
  end

  @spec bfs(pid) :: [any]
  def bfs(root_node_pid) do
    q = :queue.new()
    q = :queue.in(root_node_pid, q)
    {:ok, agent_pid} = Agent.start(fn -> [] end)
    bfs(q, agent_pid)
  end

  defp bfs(queue, agent_pid) do
    cond do
      :queue.is_empty(queue) ->
        Agent.get(agent_pid, fn traversal_data -> traversal_data end)
      true ->
        {{:value, node_pid}, queue} = :queue.out(queue)
        node_data = node_pid |> GenTree.Node.get_data()
        Agent.update(agent_pid, fn traversal_data -> traversal_data ++ [node_data] end)

        queue =
          node_pid
          |> GenTree.get_children()
          |> Enum.reverse()
          |> Enum.reduce(queue, fn child_pid, queue -> :queue.in(child_pid, queue) end)

        bfs(queue, agent_pid)
    end
  end

end
