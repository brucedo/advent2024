defmodule DayOneTest do 
  use ExUnit.Case
  doctest DayOne

  test "Given some pair of numbers in a string, when submitted to parse_string_pair, then a tuple of two numbers will be returned" do 
    pair = "1 2"

    assert DayOne.parse_string_pair(pair) == {1, 2}
  end

  test "Given some pair of numbers separated by multiple spaces in a string, when submitted to parse_string_pair, then a tuple of those two numbers will be returned" do 
    pair = "345                                                                           1455922"

    assert DayOne.parse_string_pair(pair) == {345, 1455922}
  end

  test "Given some list of pairs {a, b}, when submitted to break_pairs, then a pair of lists will be produced where each element of the left list is from a and each element of the right list is from b" do 
    pairs = [{123, 321}, {456, 654}, {789, 987}, {100000, 100001}]

    assert DayOne.break_pairs(pairs) == {[123, 456, 789, 100000], [321, 654, 987, 100001]}
  end

  test "Given some pair of lists a and b, when passed to find_distance then a single list will be returned whose value is the absolute value of the pairwise subtraction of a from b" do 
    left_list = [123, 456, 789, 100000]
    right_list = [321, 654, 987, 100001]

    assert DayOne.find_distance(left_list, right_list) == [abs(123-321), abs(456-654), abs(789-987), abs(100000 - 100001)]
  end

  test "Given some list of numbers, when passed to count_duplicates then a map relating each distinct number in the list to the number of times it occurs will be returned" do 
    input_list = [3, 4, 6, 5, 4, 6, 2, 1, 0, 2, 4, 5, 0, 1, 2, 4]

    assert DayOne.count_duplicates(input_list) == %{
      3 => 1, 
      4 => 4, 
      6 => 2, 
      5 => 2, 
      2 => 3, 
      1 => 2, 
      0 => 2, 
    }
  end

end
