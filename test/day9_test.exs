defmodule Day9Test do
  use ExUnit.Case
  import Day9
  doctest Day9

  # BlockState Advance tests

  test "Given a BlockState with a size > 1, advance() will reduce the file_size by 1" do
    state = %BlockState{size: 3, id: 333, type: :file, blocks: []}

    assert BlockState.advance(state) == %BlockState{size: 2, id: 333, type: :file, blocks: []}
  end

  test "Given a BlockState with a size == 1 and a block in the blocks list, advance will set size to that block " do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4]}

    assert BlockState.advance(state).size == 4
  end

  test "Given a BlockState with a size == 1 and at least one block in the blocks list, advance will remove the first block from the list" do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4, 8, 22]}

    assert BlockState.advance(state).blocks == [8, 22]
  end

  test "Given a BlockState with a size == 1 and a type of :file, advance() will swap the type to :empty" do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4]}

    assert BlockState.advance(state).type == :empty
  end

  test "Given a BlockState with a size == 1 and a type of :empty, advance() will swap the type to :file" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [4]}

    assert BlockState.advance(state).type == :file
  end

  test "Given a BlockState with a size == 1 and a type of :file, advance will not change the id number" do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4]}

    assert BlockState.advance(state).id == 333
  end

  test "Given a BlockState with a size == 1 and a type of :empty, advance() will increment the id number" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [4]}

    assert BlockState.advance(state).id == 334
  end

  test "Given a BlockState with a size == 1 and whose next block is size 0, advance() will increment past the 0" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [0, 4]}

    assert BlockState.advance(state).size == 4
  end

  test "Given a BlockState with a size == 1 and whose next block is size 0, advance() will toggle back to the current type" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [0, 4]}

    assert BlockState.advance(state).type == :empty
  end

  # Blockstate reverse tests

  test "Given a BlockState with a size > 1, reverse() will reduce the file_size by 1" do
    state = %BlockState{size: 3, id: 333, type: :file, blocks: []}

    assert BlockState.reverse(state) == %BlockState{size: 2, id: 333, type: :file, blocks: []}
  end

  test "Given a BlockState with a size == 1 and a block in the blocks list, reverse will set size to that block " do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4]}

    assert BlockState.reverse(state).size == 4
  end

  test "Given a BlockState with a size == 1 and at least one block in the blocks list, reverse will remove the first block from the list" do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4, 8, 22]}

    assert BlockState.reverse(state).blocks == [8, 22]
  end

  test "Given a BlockState with a size == 1 and a type of :file, reverse() will swap the type to :empty" do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4]}

    assert BlockState.reverse(state).type == :empty
  end

  test "Given a BlockState with a size == 1 and a type of :empty, reverse() will swap the type to :file" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [4]}

    assert BlockState.reverse(state).type == :file
  end

  test "Given a BlockState with a size == 1 and a type of :file, reverse will not change the id number" do
    state = %BlockState{size: 1, id: 333, type: :file, blocks: [4]}

    assert BlockState.reverse(state).id == 333
  end

  test "Given a BlockState with a size == 1 and a type of :empty, reverse() will decrement the id number" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [4]}

    assert BlockState.reverse(state).id == 332
  end

  test "Given a BlockState with a size == 1 and whose next block is size 0, reverse() will increment past the 0" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [0, 4]}

    assert BlockState.reverse(state).size == 4
  end

  test "Given a BlockState with a size == 1 and whose next block is size 0, reverse() will toggle back to the current type" do
    state = %BlockState{size: 1, id: 333, type: :empty, blocks: [0, 4]}

    assert BlockState.reverse(state).type == :empty
  end

  # Checksum calculation tests

  test "Given reverse_position < forward_position, checksum() will return 0" do
    forward_position = 5
    reverse_position = 4
    assert checksum(forward_position, %BlockState{}, reverse_position, %BlockState{}) == 0
  end

  test "Given reverse_position == forward_position and a non-empty block in the forward running block state, checksum() will return forward_position * forward_block.id" do
    forward_position = 5
    forward_block = %BlockState{size: 4, id: 22, type: :file, blocks: []}
    reverse_position = 5

    assert checksum(forward_position, forward_block, reverse_position, %BlockState{}) == 5 * 22
  end

  test "Given reverse_position == forward_position, empty block in the forward running block state, and a file block in the reverse running BlockState then checksum() will return forward_position * reverse_block.id" do
    forward_position = 5
    forward_block = %BlockState{size: 4, id: 22, type: :empty, blocks: []}
    reverse_position = 5
    reverse_block = %BlockState{size: 3, id: 34, type: :file, blocks: []}

    assert checksum(forward_position, forward_block, reverse_position, reverse_block) == 5 * 34
  end

  test "Given reverse_position == forward_position, empty block in the forward running block state, and empty block in the reverse running BlockState then checksum() will return 0" do
    forward_position = 5
    forward_block = %BlockState{size: 4, id: 22, type: :empty, blocks: []}
    reverse_position = 5
    reverse_block = %BlockState{size: 3, id: 34, type: :empty, blocks: []}

    assert checksum(forward_position, forward_block, reverse_position, reverse_block) == 0
  end

  test "Given a file such that file size + forward position is at least as large as the reverse_position then checksum will produce the sum of the product of the block index and the file id" do
    forward_position = 1
    forward_block = %BlockState{size: 5, id: 22, type: :file, blocks: []}
    reverse_position = 5
    reverse_block = %BlockState{}

    assert checksum(forward_position, forward_block, reverse_position, reverse_block) ==
             1 * 22 + 2 * 22 + 3 * 22 + 4 * 22 + 5 * 22
  end

  test "Given a forward block with a filled block and subsequent empty block of size e and a reverse block with a file of at least size e then checksum() will generate a checksum across positions forward_position to reverse_position" do
    forward_position = 1
    forward_block = %BlockState{size: 5, id: 22, type: :file, blocks: [4]}
    reverse_position = 13
    reverse_block = %BlockState{size: 4, id: 33, type: :file, blocks: []}

    assert checksum(forward_position, forward_block, reverse_position, reverse_block) ==
             1 * 22 + 2 * 22 + 3 * 22 + 4 * 22 + 5 * 22 + 6 * 33 + 7 * 33 + 8 * 33 + 9 * 33
  end

  test "Given a forward file followed by an empty block and a reverse empty followed by a file, checksum() will calculate the checksum of the forward file followed by as much of the reverse file as it can cram into the empty slot" do
    forward_position = 1
    forward_block = %BlockState{size: 5, id: 22, type: :file, blocks: [4]}
    reverse_position = 17
    reverse_block = %BlockState{size: 4, id: 33, type: :empty, blocks: [4]}

    assert checksum(forward_position, forward_block, reverse_position, reverse_block) ==
             1 * 22 + 2 * 22 + 3 * 22 + 4 * 22 + 5 * 22 + 6 * 32 + 7 * 32 + 8 * 32 + 9 * 32
  end

  test "Given a forward block with a subsequent 0-sized free block and a subsequent non-zero file block, and a reverse_block with a non-zero sized file_block then checksum() will generate a checksum across only the forward blocks" do
    forward_position = 0
    forward_block = %BlockState{size: 9, id: 0, type: :file, blocks: [0, 9]}
    reverse_position = 17
    reverse_block = %BlockState{size: 9, id: 2, type: :file, blocks: [0, 9]}

    assert checksum(forward_position, forward_block, reverse_position, reverse_block) ==
             0 * 0 + 1 * 0 + 2 * 0 + 3 * 0 + 4 * 0 + 5 * 0 + 6 * 0 + 7 * 0 + 8 * 0 +
               9 * 1 + 10 * 1 + 11 * 1 + 12 * 1 + 13 * 1 + 14 * 1 + 15 * 1 + 16 * 1 + 17 * 1
  end

  test "Given a simple list [1, 2] split_file_map() will return a list with one file of size 1 at index 0 with id 0 and a list with one empty space of size 2 " do
    file_map = [1, 2]

    assert Day9.split_file_map(file_map, 0, 0, :file) == {[{0, 1, 0}], [{1, 2}]}
  end

  test "Given a lsit [9, 0, 9, 0, 9] split_file_map() will return a list with three files of size 9 and 2 empty zones of size 0" do
    file_map = [9, 0, 9, 0, 9]

    assert Day9.split_file_map(file_map, 0, 0, :file) ==
             {[{0, 9, 0}, {9, 9, 1}, {18, 9, 2}], [{9, 0}, {18, 0}]}
  end

  test "Given the start index 9, the size 9 and the id 1, file_checksum() will produce the sum of 9..17 inclusive" do
    file = {9, 9, 1}

    assert Day9.file_checksum(elem(file, 0), elem(file, 1), elem(file, 2)) ==
             9 + 10 + 11 + 12 + 13 + 14 + 15 + 16 + 17
  end

  test "Given the start index 4, the size 6 and the id 5, file checksum will produce an appropriate total " do
    file = {4, 6, 5}

    assert Day9.file_checksum(elem(file, 0), elem(file, 1), elem(file, 2)) ==
             4 * 5 + 5 * 5 + 6 * 5 + 7 * 5 + 8 * 5 + 9 * 5
  end

  test "Given a list of empty space pairs, bucketify will place the index for each pair into a list categorized by the empty space" do
    empties = [{2, 3}, {8, 3}, {12, 3}, {18, 1}, {21, 1}, {26, 1}, {31, 1}, {35, 1}, {40, 0}]

    assert Day9.bucketify(empties) == %{
             0 => [40],
             1 => [18, 21, 26, 31, 35],
             2 => [],
             3 => [2, 8, 12],
             4 => [],
             5 => [],
             6 => [],
             7 => [],
             8 => [],
             9 => []
           }
  end

  test "Given an empty space map and a file_triple, shift_left will set the start_index of the returned file to the leftmost empty that can hold it" do
    empty_space_map = %{
      0 => [40],
      1 => [18, 21, 26, 31, 35],
      2 => [],
      3 => [2, 8, 12],
      4 => [],
      5 => [],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    file_triple = {40, 2, 9}

    {_, updated_file_triple} = Day9.shift_left(empty_space_map, file_triple)

    assert updated_file_triple = {2, 2, 9}
  end

  test "Given an empty space map and a file_triple, shift_left will remove the leftmost empty that can hold the file from its original empty space map bucket" do
    empty_space_map = %{
      0 => [40],
      1 => [18, 21, 26, 31, 35],
      2 => [],
      3 => [2, 8, 12],
      4 => [],
      5 => [],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    file_triple = {40, 2, 9}

    {updated_space_map, _} = Day9.shift_left(empty_space_map, file_triple)

    assert Map.get(updated_space_map, 3) == [8, 12]
  end

  test "Given an empty space map and a file_triple, shift_left will place a new entry in bucket (original_bucket_size - file_triple_size) in the empty space map with index (original_empty_index + fitted_file_size)" do
    empty_space_map = %{
      0 => [40],
      1 => [18, 21, 26, 31, 35],
      2 => [],
      3 => [2, 8, 12],
      4 => [],
      5 => [],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    file_triple = {40, 2, 9}

    {updated_space_map, _} = Day9.shift_left(empty_space_map, file_triple)

    assert Map.get(updated_space_map, 1) == [4, 18, 21, 26, 31, 35]
  end

  test "Given an empty space map and a file_triple that cannot be moved, shift_left will simply return the original file triple" do
    empty_space_map = %{
      0 => [40],
      1 => [18, 21, 26, 31, 35],
      2 => [],
      3 => [2, 8, 12],
      4 => [],
      5 => [],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    file_triple = {40, 4, 9}

    {_, original_file_triple} = Day9.shift_left(empty_space_map, file_triple)

    assert original_file_triple == file_triple
  end

  test "Given an empty space map and a file_triple that cannot be moved, shift_left will return the original empty space map" do
    empty_space_map = %{
      0 => [40],
      1 => [18, 21, 26, 31, 35],
      2 => [],
      3 => [2, 8, 12],
      4 => [],
      5 => [],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    file_triple = {40, 4, 9}

    {original_space_map, _} = Day9.shift_left(empty_space_map, file_triple)

    assert original_space_map == empty_space_map
  end

  test "Given an empty space map and a file_triple whose only fittable space is to the right, shift_left will return the original file triple" do
    empty_space_map = %{
      0 => [40],
      1 => [18, 21, 26, 31, 35],
      2 => [],
      3 => [2, 8, 12],
      4 => [],
      5 => [44],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    file_triple = {40, 4, 9}

    {_, original_file_triple} = Day9.shift_left(empty_space_map, file_triple)

    assert original_file_triple == file_triple
  end

  test "Given an empty space map and a file triple whose only fittable space is to the right, shift_left will return the original empty space map" do
    empty_space_map = %{
      0 => [40],
      1 => [18, 21, 26, 31, 35],
      2 => [],
      3 => [2, 8, 12],
      4 => [],
      5 => [5],
      6 => [],
      7 => [],
      8 => [],
      9 => []
    }

    file_triple = {40, 4, 9}

    {original_space_map, _} = Day9.shift_left(empty_space_map, file_triple)

    assert original_space_map == empty_space_map
  end
end
