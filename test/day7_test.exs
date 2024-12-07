defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "Given some text string of the format ([0-9]+):( +[0-9]+)+, then decompose_calibration will produce result {$1, [$2...]}" do
    calibration_line = "161011: 16 10  13"

    assert Day7.decompose_calibration(calibration_line) == {161_011, [16, 10, 13]}
  end

  test "Given some pair of numbers a and b  permute_operations will return {a + b, a * b}" do
    assert Day7.permute_operations(7, 9) == {7 + 9, 7 * 9}
  end

  test "Given some list of numbers permute_list will return a list of all possible sums and multiplications of all numbers" do
    measurements = [11, 6, 16, 20]

    permutations = Day7.permute_list(measurements)

    assert length(permutations) == 8

    assert Enum.member?(permutations, 53)
    assert Enum.member?(permutations, 660)
    assert Enum.member?(permutations, 292)
    assert Enum.member?(permutations, 5440)
    assert Enum.member?(permutations, 102)
    assert Enum.member?(permutations, 1640)
    assert Enum.member?(permutations, 1076)
    assert Enum.member?(permutations, 21120)
  end

  test "Given some pair of numbers a and b permute_with_catenate will return {a + b, a * b, a || b}" do
    assert Day7.permute_with_catenate(11, 16) == {27, 11 * 16, 1116}
  end

  test "Given some list of numbers permute_list_with_catenate will return a list of all possible sums, multiplications and catenations of all numbers" do
    measurements = [11, 6, 16, 20]

    permutations = Day7.permute_list_with_catenate(measurements)

    assert length(permutations) == 27

    assert Enum.member?(permutations, 53)
    assert Enum.member?(permutations, 660)
    assert Enum.member?(permutations, 3320)
    assert Enum.member?(permutations, 292)
    assert Enum.member?(permutations, 5440)
    assert Enum.member?(permutations, 27220)
    assert Enum.member?(permutations, 1736)
    assert Enum.member?(permutations, 34320)
    assert Enum.member?(permutations, 171_620)
    assert Enum.member?(permutations, 102)
    assert Enum.member?(permutations, 1640)
    assert Enum.member?(permutations, 8220)
    assert Enum.member?(permutations, 1076)
    assert Enum.member?(permutations, 21120)
    assert Enum.member?(permutations, 105_620)
    assert Enum.member?(permutations, 6636)
    assert Enum.member?(permutations, 132_320)
    assert Enum.member?(permutations, 661_620)
    assert Enum.member?(permutations, 152)
    assert Enum.member?(permutations, 2640)
    assert Enum.member?(permutations, 13220)
    assert Enum.member?(permutations, 1876)
    assert Enum.member?(permutations, 37120)
    assert Enum.member?(permutations, 185_620)
    assert Enum.member?(permutations, 11636)
    assert Enum.member?(permutations, 232_320)
    assert Enum.member?(permutations, 1_161_620)
  end
end
