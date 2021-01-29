defmodule GenTree.Builder do
  @moduledoc false

  def from_list(data_list, opts)

  def from_list([], _opts), do: GenTree.new(:nil)

  def from_list([head_data| rest_data], opts) do
    root = GenTree.new(head_data)
    q = :queue.new()
    q = :queue.in(root, q)
    nary = opts |> Keyword.get(:nary)

    build(Enum.chunk_every(rest_data, nary), root, q, nary)
  end

  defp build([], root, _queue, _nary), do: root

  defp build([hd_children_chunk| rest_children_chunk], root, queue, nary) do
    {{:value, parent_pid}, queue} = :queue.out(queue)
    queue =
      hd_children_chunk
      |> Enum.with_index()
      |> Enum.filter(fn {data, _index} -> not is_nil(data) end)
      |> Enum.map(fn {data, index} -> insert_child(nary, rem(index, 2) === 0 , parent_pid, data) end)
      |> Enum.reduce(queue, fn child_pid, queue -> :queue.in(child_pid, queue) end)

    build(rest_children_chunk, root, queue, nary)
  end

  defp insert_child(nary, is_left, parent_pid, data)
  defp insert_child(2, true, parent_pid, data) do
    GenTree.insert_child(parent_pid, data, :left)
  end
  defp insert_child(2, false, parent_pid, data) do
    GenTree.insert_child(parent_pid, data, :right)
  end
  defp insert_child(_nary, _is_left, parent_pid, data) do
    GenTree.insert_child(parent_pid, data)
  end

end
