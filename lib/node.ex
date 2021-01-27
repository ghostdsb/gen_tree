defmodule GenTree.Node do

  defstruct(
    data: nil,
    left: nil,
    right: nil,
    children: []
  )

  def new(data) do
    {:ok, pid} = Agent.start(fn -> GenTree.Node.__struct__() |> Map.put(:data, data) end)
    pid
  end

  def get_node(pid) do
    Agent.get(pid, fn state -> state end)
  end

  def get_left(pid) do
    Agent.get(pid, fn state -> state.left end)
  end

  def get_right(pid) do
    Agent.get(pid, fn state -> state.right end)
  end

  def left?(pid) do
    Agent.get(pid, fn state -> not is_nil(state.left)  end)
  end

  def right?(pid) do
    Agent.get(pid, fn state -> not is_nil(state.right) end)
  end

  def get_children(pid) do
    Agent.get(pid, fn state -> state.children end)
  end

  def update_data(pid, data) do
    Agent.get(pid, fn state -> %{state | data: data} end)
  end

  def update_node(pid, new_state) do
    Agent.get(pid, fn _ -> new_state end)
  end

  def insert_child(parent_pid, data, child_type) do
    child_pid = new(data)
    case child_type do
      :left ->
        Agent.update(parent_pid, fn state -> %{state | children: [child_pid | state.children], left: child_pid} end)
      :right ->
        Agent.update(parent_pid, fn state -> %{state | children: [child_pid | state.children], right: child_pid} end)
      _ ->
        Agent.update(parent_pid, fn state -> %{state | children: [child_pid | state.children]} end)
    end
    child_pid
  end

end
