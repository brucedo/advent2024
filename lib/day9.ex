defmodule BlockState do
  defstruct size: -1, id: -1, type: :file, blocks: []

  @spec advance(%BlockState{}) :: %BlockState{}
  def advance(block) do
    shift(block, &+/2)
  end

  def reverse(block) do
    shift(block, &-/2)
  end

  defp shift(%BlockState{size: 1, id: id, type: type, blocks: [next | rest]}, id_op) do
    # next_type =
    #   if type == :file do
    #     :empty
    #   else
    #     :file
    #   end
    {next_block, remaining_blocks, next_type} = find_next_valid(next, rest, type)

    next_id =
      if next_type == :file do
        id_op.(id, 1)
      else
        id
      end

    %BlockState{size: next_block, id: next_id, type: next_type, blocks: remaining_blocks}
  end

  defp shift(%BlockState{size: size, id: id, type: type, blocks: blocks}, _) do
    %BlockState{size: size - 1, id: id, type: type, blocks: blocks}
  end

  defp swap_type(type) do
    if type == :file do
      :empty
    else
      :file
    end
  end

  defp find_next_valid(0, [next | rest], last_type) do
    find_next_valid(next, rest, swap_type(last_type))
  end

  defp find_next_valid(next, blocks, last_type) do
    {next, blocks, swap_type(last_type)}
  end
end

defmodule FileTriple do
  defstruct index: -1, size: -1, id: -1
end

defmodule Day9 do
  require Logger

  def run() do
    lines =
      Common.open(File.cwd(), "day9.txt") |> Common.read_file_pipe() |> Common.close()

    file_blocks_forward =
      List.first(lines) |> String.graphemes() |> Enum.map(&String.to_integer/1)

    file_blocks_reversed = Enum.reverse(file_blocks_forward)
    total_blocks = Enum.sum(file_blocks_forward)
    last_file_id = Integer.floor_div(length(file_blocks_forward), 2)
    last_block_file? = rem(length(file_blocks_forward), 2) == 1

    [first_block | rest_forward] = file_blocks_forward
    [last_block | rest_backward] = file_blocks_reversed

    forward_tracker = %BlockState{size: first_block, id: 0, type: :file, blocks: rest_forward}

    backward_tracker = %BlockState{
      size: last_block,
      id: last_file_id,
      type:
        if last_block_file? do
          :file
        else
          :empty
        end,
      blocks: rest_backward
    }

    total_checksum = checksum(0, forward_tracker, total_blocks - 1, backward_tracker)

    IO.puts("The total checksum calculated is #{inspect(total_checksum)}")

    left_shifted_files = run_left_shifts(file_blocks_forward)

    Logger.debug("left shifted files: #{inspect(left_shifted_files)}")

    checksums =
      Enum.map(left_shifted_files, fn %FileTriple{index: index, size: size, id: id} ->
        file_checksum(index, size, id)
      end)

    final_total_checksum = Enum.sum(checksums)
    IO.puts("The NEW total checksum calculated is #{inspect(final_total_checksum)}")
  end

  @spec checksum(integer(), %BlockState{}, integer(), %BlockState{}) :: integer()
  def checksum(forward_index, _, reverse_index, _) when forward_index > reverse_index do
    0
  end

  def checksum(forward_index, forward_blocks, reverse_index, reverse_blocks) do
    # Logger.debug("Before all updates: ")
    # Logger.debug("  forward_index is #{inspect(forward_index)}")
    # Logger.debug("  forward_blocks is #{inspect(forward_blocks)}")
    # Logger.debug("  reverse_index is #{inspect(reverse_index)}")
    # Logger.debug("  reverse_blocks is #{inspect(reverse_blocks)}")

    product =
      case {forward_blocks.type, reverse_blocks.type} do
        {:file, _} -> forward_index * forward_blocks.id
        {:empty, :file} -> forward_index * reverse_blocks.id
        {:empty, :empty} -> 0
      end

    {next_reverse_index, next_reverse_blocks} =
      case forward_blocks.type do
        :empty -> {reverse_index - 1, BlockState.reverse(reverse_blocks)}
        :file -> {reverse_index, reverse_blocks}
      end

    {next_forward_index, next_forward_blocks} =
      case {forward_blocks.type, reverse_blocks.type} do
        {:file, _} -> {forward_index + 1, BlockState.advance(forward_blocks)}
        {:empty, :file} -> {forward_index + 1, BlockState.advance(forward_blocks)}
        {:empty, :empty} -> {forward_index, forward_blocks}
      end

    # Logger.debug("After all updates:")
    # Logger.debug("  forward_index is #{inspect(next_forward_index)}")
    # Logger.debug("  forward_blocks is #{inspect(next_forward_blocks)}")
    # Logger.debug("  reverse_index is #{inspect(next_reverse_index)}")
    # Logger.debug("  reverse_blocks is #{inspect(next_reverse_blocks)}")
    # Logger.debug("  product is #{inspect(product)}")

    product +
      checksum(next_forward_index, next_forward_blocks, next_reverse_index, next_reverse_blocks)
  end

  @spec split_file_map(list(integer()), integer(), integer(), atom()) ::
          {list(%FileTriple{}), list({integer(), integer()})}
  def split_file_map([], _, _, _) do
    {[], []}
  end

  def split_file_map([next_object | remainder], index, id, type) do
    case type do
      :file ->
        {files, empties} = split_file_map(remainder, index + next_object, id + 1, :empty)
        {[%FileTriple{index: index, size: next_object, id: id} | files], empties}

      :empty ->
        {files, empties} = split_file_map(remainder, index + next_object, id, :file)
        {files, [{index, next_object} | empties]}
    end
  end

  @spec run_left_shifts(list(integer())) :: list(%FileTriple{})
  def run_left_shifts(original_list) do
    {list_of_files, list_of_empties} = split_file_map(original_list, 0, 0, :file)
    empty_map = bucketify(list_of_empties)

    files_to_shuffle = Enum.reverse(list_of_files)

    # Logger.debug("Empty map being passed to actual_run_shifts: #{inspect(empty_map)}")
    actual_run_shifts(files_to_shuffle, empty_map)
  end

  @spec actual_run_shifts(
          list(%FileTriple{}),
          %{integer() => list(integer())}
        ) ::
          list(%FileTriple{})
  defp actual_run_shifts([], _empty_map) do
    []
  end

  defp actual_run_shifts([next_file | files], empty_map) do
    # Logger.debug("Map in actual_run_shifts: #{inspect(empty_map)}")
    {updated_map, updated_file} = shift_left(empty_map, next_file)

    # Logger.debug("Updated map in actual_run_shifts: #{inspect(updated_map)}")
    # Logger.debug("Updated file in actual_run_shifts: #{inspect(updated_file)}")

    [updated_file | actual_run_shifts(files, updated_map)]
  end

  def file_checksum(start_index, block_length, file_id) do
    for index <- start_index..(start_index + block_length - 1) do
      index * file_id
    end
    |> Enum.sum()
  end

  @spec bucketify(list({integer(), integer()})) :: %{integer() => list(integer())}
  def bucketify(empties) do
    buckets = %{
      0 => [],
      1 => [],
      2 => [],
      3 => [],
      4 => [],
      5 => [],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    buckets =
      Enum.reduce(empties, buckets, fn {index, size}, acc ->
        elem(
          Map.get_and_update(acc, size, fn value ->
            {value,
             if value == nil do
               [index]
             else
               [index | value]
             end}
          end),
          1
        )
      end)

    Enum.reduce(Map.keys(buckets), buckets, fn size, acc ->
      elem(
        Map.get_and_update(acc, size, fn empty_list ->
          {empty_list, Enum.sort(empty_list)}
        end),
        1
      )
    end)
  end

  @spec shift_left(%{integer() => list(integer())}, %FileTriple{}) ::
          {%{integer() => list(integer())}, %FileTriple{}}
  def shift_left(empty_map, %FileTriple{index: file_index, size: size, id: id}) do
    Logger.debug("Map: #{inspect(empty_map)}")

    matching_buckets =
      for index <- size..9 do
        {index, Map.get(empty_map, index)}
      end
      |> Enum.map(fn {bucket, smallest_indices} ->
        {bucket, Enum.filter(smallest_indices, &(&1 < file_index))}
      end)
      |> Enum.filter(fn {_, smallest_index} -> smallest_index != nil && smallest_index != [] end)

    Logger.debug("Matching buckets: #{inspect(matching_buckets)}")

    case matching_buckets do
      [] ->
        {empty_map, %FileTriple{index: file_index, size: size, id: id}}

      matches ->
        {bucket, [smallest_index | rest_of_indices]} = Enum.min_by(matches, &elem(&1, 1))
        new_bucket = bucket - size
        new_index = smallest_index + size

        updated_map = Map.replace(empty_map, bucket, rest_of_indices)

        updated_map =
          Map.replace(
            updated_map,
            new_bucket,
            [new_index | Map.get(updated_map, new_bucket)] |> Enum.sort()
          )

        {updated_map, %FileTriple{index: smallest_index, size: size, id: id}}
    end
  end
end
