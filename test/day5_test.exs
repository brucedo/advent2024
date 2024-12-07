defmodule Day5Test do
  require Logger
  use ExUnit.Case
  doctest Day5

  test "Given a list [1, 2], when passed as a parameter to expand_pages, then the result will be [{1, 2}]" do
    updates = [1, 2]

    assert Day5.expand_pages(updates) == [{1, 2}]
  end

  test "Given a list [1 , 2, 3], when passed as parameter to expand_pages, then the result will include {1, 2}, {1, 3}, and {2, 3}" do
    updates = [1, 2, 3]

    pairs = Day5.expand_pages(updates)

    assert length(pairs) == 3
    assert Enum.member?(pairs, {1, 2})
    assert Enum.member?(pairs, {1, 3})
    assert Enum.member?(pairs, {2, 3})
  end

  test "Given some list of pairs, when passed as a parameter to flip(), then the result will be a list of pairs whose elements are swapped" do
    pairs = [{1, 2}, {1, 3}, {2, 3}]

    flipped = Day5.flip(pairs)

    assert length(flipped) == 3
    assert Enum.member?(flipped, {2, 1})
    assert Enum.member?(flipped, {3, 1})
    assert Enum.member?(flipped, {3, 2})
  end

  test "Given some string of the form x|y where x and y are numbers, when passed to make_rule(), then a tuple {x, y} will be returned" do
    rule_str = "29|13"

    assert Day5.make_rule(rule_str) == {29, 13}
  end

  test "Given an empty list and a new pair {first, second}, when passed to ordered_insert(), then the list [first, second] will be returned" do
    ordered_pair = {47, 53}

    assert Day5.ordered_insert([], ordered_pair) == [47, 53]
  end

  test "Given an ordered list with at least one element and a new pair whose members are disjoint with the list, then ordered_insert will append both new elements" do
    ordered_pair = {47, 53}

    assert Day5.ordered_insert([97, 13], ordered_pair) == [97, 13, 47, 53]
  end

  test "Given an ordered list with at least one element and a new pair whose first member exists in the list, then ordered insert will append the second new element to the ordered list" do
    ordered_pair = {47, 53}

    fixed_list = Day5.ordered_insert([97, 47, 13], ordered_pair)

    assert Day5.ordered_insert([97, 47, 13], ordered_pair) == [97, 47, 13, 53]
  end

  test "Given an ordered list with at least one element and a new pair whose second member exists in the list, then ordered insert will insert the first new element before the second in the ordered list" do
    ordered_pair = {47, 53}

    assert Day5.ordered_insert([97, 53, 13], ordered_pair) == [97, 47, 53, 13]
  end

  test "Given an ordered list with at least one element and a new pair whose members both occur in the same order in the list, then ordered insert will return the original list" do
    ordered_pair = {47, 53}

    fixed_list = Day5.ordered_insert([97, 47, 53, 13], ordered_pair)
    Logger.debug("Trying to get the fucking output you cunts")
    Enum.each(fixed_list, fn number -> Logger.debug("#{Integer.to_string(number)}") end)

    assert Day5.ordered_insert([97, 47, 53, 13], ordered_pair) == [97, 47, 53, 13]
  end

  test "Given an ordered list with at least one element and a new pair whose members occur out of order in the list, then ordered insert will return a list with the first new element moved before the second new element" do
    ordered_pair = {47, 53}

    assert Day5.ordered_insert([97, 53, 13, 47], ordered_pair) == [97, 47, 53, 13]
  end

  test "Just checking the example set..." do
    ordered_pairs = [
      {47, 53},
      {97, 13},
      {97, 61},
      {97, 47},
      {75, 29},
      {61, 13},
      {75, 53},
      {29, 13},
      {97, 29},
      {53, 29},
      {61, 53},
      {97, 53},
      {61, 29},
      {47, 13},
      {75, 47},
      {97, 75},
      {47, 61},
      {75, 61},
      {47, 29},
      {75, 13},
      {53, 13}
    ]

    assert Enum.reduce(ordered_pairs, [], fn elem, acc -> Day5.ordered_insert(acc, elem) end) == [
             97,
             75,
             47,
             61,
             53,
             29,
             13
           ]
  end
end
