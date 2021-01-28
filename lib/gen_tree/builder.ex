defmodule GenTree.Builder do
  @moduledoc false

  def build_tree_level_order(data_list)

  def build_tree_level_order([]), do: GenTree.new(:nil)

  def build_tree_level_order([head_data| rest_data_list]) do
    root = GenTree.new(head_data)
    q = :queue.new()
    q = :queue.in(root, q)
    build_tree_level_order(rest_data_list, root, q)
  end

  def build_tree_level_order([], root, _queue), do: root

  def build_tree_level_order([head_data| rest_data], root, queue) do
    queue_head = :queue.head(queue)

    {child_node_pid, queue} =
      cond do
        not GenTree.left?(queue_head) ->
          child_node = GenTree.insert_child(queue_head, head_data, :left)
          {child_node, queue}
        not GenTree.right?(queue_head) ->
          child_node = GenTree.insert_child(queue_head, head_data, :right)
          {child_node, :queue.tail(queue)}
      end

    build_tree_level_order(rest_data, root, :queue.in(child_node_pid, queue))
  end

end
