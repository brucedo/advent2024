defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "Given a stone marked 0, mutate will return a list of a single stone marked [1]" do
    stone = 0

    assert Day11.mutate(stone) == [1]
  end

  test "Given a stone marked with an even number of digits, mutate will return a pair of stones whose digits are the first half and the second half of the parent" do
    stone = 123_456

    assert Day11.mutate(stone) == [123, 456]
  end

  test "Given a stone marked with an odd number of digits, mutate will return a list of a single stone whose digits are the the parent's multiplied by 2024" do
    stone = 12345

    assert Day11.mutate(stone) == [12345 * 2024]
  end

  test "Given a single digit 0 and the number 4, run_sequence() will generate [2, 0, 2, 4]" do
    stone = 0

    assert Day11.run_sequence(stone, 4) == [2, 0, 2, 4]
  end
end
