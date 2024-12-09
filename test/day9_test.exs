defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "Given some string comprised of numbers, string_to_numbers will produce a Stream of single-digit numbers." do
    disk_map = "2333133121414131402"

    assert Day9.string_to_numbers(disk_map) == [
             2,
             3,
             3,
             3,
             1,
             3,
             3,
             1,
             2,
             1,
             4,
             1,
             4,
             1,
             3,
             1,
             4,
             0,
             2
           ]
  end

  test "Given a triple representing {block_size, block_position, block_id}, when block_position < block_size - 1, then step will return {block_size, block_position + 1, block_id}" do
    block = {3, 1, 2}

    assert Day9.step(block) == {3, 2, 2}
  end

  test "Given a triple representing {block_size, block_position, block_id}, when block_position >= block_size - 1, then step() will return :eob" do
    block = {3, 2, 2}

    assert Day9.step(block) == :eob
  end

  test "Given a triple representing {block_size, block_position, :empty}, when block_position < block_ size - 1, then step will return {block_size, block_position + 1, :empty}" do
    block = {3, 1, :empty}

    assert Day9.step(block) == {3, 2, :empty}
  end

  test "Given a triple representing {block_size, block_position, block_id}, when block_position > 0 then copy() will return {{block_size, block_position - 1, block_id}, block_id}" do
    block = {3, 2, 5}

    assert Day9.copy(block) == {{3, 1, 5}, 5}
  end

  test "Given a triple representing {block_size, block_position, block_id}, when block_position == 0 then copy() will return {:eob, block_id}" do
    block = {3, 0, 5}

    assert Day9.copy(block) == {:eob, 5}
  end

  test "Give "
end
