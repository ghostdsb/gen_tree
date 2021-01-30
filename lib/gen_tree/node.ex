defmodule GenTree.Node do
  @moduledoc false

  defstruct(
    data: nil,
    left: nil,
    right: nil,
    parent: nil,
    children: []
  )

  def new(data) do
    {:ok, node_pid} = Agent.start(fn -> GenTree.Node.__struct__() |> Map.put(:data, data) end)
    node_pid
  end

  def get_data(node_pid) do
    Agent.get(node_pid, fn state -> state.data end)
  end

  def set_parent(self_pid, parent_pid) do
    Agent.update(self_pid, fn state -> %{state | parent: parent_pid} end)
  end

  def get_parent(node_pid) do
    Agent.get(node_pid, fn state -> state.parent end)
  end

  def get_children(node_pid) do
    Agent.get(node_pid, fn state -> state.children end)
  end

  def count_children(node_pid) do
    node_pid |> get_children() |> Enum.count()
  end

  def get_node(node_pid) do
    Agent.get(node_pid, fn state -> state end)
  end

  def get_left(node_pid) do
    Agent.get(node_pid, fn state -> state.left end)
  end

  def get_right(node_pid) do
    Agent.get(node_pid, fn state -> state.right end)
  end

  def has_left?(node_pid) do
    Agent.get(node_pid, fn state -> not is_nil(state.left)  end)
  end

  def has_right?(node_pid) do
    Agent.get(node_pid, fn state -> not is_nil(state.right) end)
  end

  def update_data(node_pid, data) do
    Agent.update(node_pid, fn state -> %{state | data: data} end)
  end

  def update_node(node_pid, new_state) do
    Agent.get(node_pid, fn _ -> new_state end)
  end

  def insert_child(parent_node_pid, data, child_type) do
    child_node_pid = new(data)
    set_parent(child_node_pid, parent_node_pid)
    case child_type do
      :left ->
        Agent.update(parent_node_pid, fn state -> %{state | children: [child_node_pid | state.children], left: child_node_pid} end)
      :right ->
        Agent.update(parent_node_pid, fn state -> %{state | children: [child_node_pid | state.children], right: child_node_pid} end)
      _ ->
        Agent.update(parent_node_pid, fn state -> %{state | children: [child_node_pid | state.children]} end)
    end
    child_node_pid
  end

end
