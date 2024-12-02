defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "Given some list of numbers that is only decreasing, when passed to monotonic?, then a true will be returned" do
    decreasing = [10, 9, 8, 4, 2, -1, -12, -100]

    assert Day2.monotonic?(decreasing)
  end

  test "Given some list of numbers that is only increasing, when passed to monotonic?, then a true will be returned" do
    increasing = [-1000, -999, -800, 0, 1, 2, 3, 4, 6, 100, 10_000_000]

    assert Day2.monotonic?(increasing)
  end

  test "Given some list of numbers that increases and decreases over its range, when passed to monotonic?, then false will be returned" do
    all_over_the_place = [-1000, -599, -200, 0, 1, 0, 1, 2, 3, 4, 1_000_000]

    refute Day2.monotonic?(all_over_the_place)
  end

  test "Given some list of numbers where each adjacent pair differ by at most 3 and at least 1, when passed to gradual?, then true will be returned" do
    gradual = [1, 2, 4, 5, 8, 6, 4, 1, -1, -4, -5, -2, 1]

    assert Day2.gradual?(gradual)
  end

  test "Given some list of numbers where at least one adjaent pair differ by less than 1, when passed to gradual?, then false will be returned" do
    equal_pair = [1, 2, 2, 4, 5, 8]

    refute Day2.gradual?(equal_pair)
  end

  test "Given some list of numbers where at least one adjacent pair differs by more than 3, when passed to gradual?, then false will be returned" do
    big_jump = [1, 2, 4, 8, 11, 12]

    refute Day2.gradual?(big_jump)
  end

  test "Given the sample input, when provided to test_safety then 2 reports will be found to be safe" do
    reports = [
      [7, 6, 4, 2, 1],
      [1, 2, 7, 8, 9],
      [9, 7, 6, 2, 1],
      [1, 3, 2, 4, 5],
      [8, 6, 4, 4, 1],
      [1, 3, 6, 7, 9]
    ]

    assert Day2.test_safety(reports) == 2
  end

  test "Given a montonically increasing list of numbers, when provided to dampened_monotonic?, then true will be returned" do
    increasing = [-1000, -999, -800, 0, 1, 2, 3, 4, 6, 100, 10_000_000]

    assert Day2.dampened_monotonic?(increasing)
  end

  test "Given a list of numbers that ascends save for one pair, when provided to dampened_monotonic?, then true will be returned" do
    increasing = [-1000, -999, -800, 0, 1, 2, 3, 4, 3, 6, 100, 10_000_000]

    assert Day2.dampened_monotonic?(increasing)
  end

  test "Given a list of numbers that ascends safe for two pairs, when provided to dampened_monotonic?, then false will be returned" do
    increasing_bad = [-1000, -999, -800, 0, 1, 2, 1, 3, 4, 3, 6, 100, 10_000_000]

    refute Day2.dampened_monotonic?(increasing_bad)
  end

  test "Given a list of numbers that monotonically decreases, when provided to dampened_monotonic, then true will be returned" do
    decreasing = [10, 9, 8, 4, 2, -1, -12, -100]

    assert Day2.dampened_monotonic?(decreasing)
  end

  test "Given a list of numbers that descends save for one pair, when provided to dampening_monotonic?, then true will be returned" do
    decreasing = [10, 9, 8, 4, 5, 2, -1, -12, -100]

    assert Day2.dampened_monotonic?(decreasing)
  end

  test "Given a list of numbers that descends save for two pairs, when provided to dampening_monotonic?, then false will be returned" do
    decreasing = [10, 9, 8, 4, 5, 2, -1, 0, -12, -100]

    refute Day2.dampened_monotonic?(decreasing)
  end

  test "Given a list of numbers where each adjacent pair differs by at most 3 and at least 1, when passed to dampened_gradual?, then true will be returned" do
    gradual = [1, 2, 4, 5, 8, 6, 4, 1, -1, -4, -5, -2, 1]

    assert Day2.dampened_gradual?(gradual)
  end

  test "Given a list of numbers where at most one adjacent pair differs by more than 3, when passed to dampened_gradual?, then true will be returned" do
    gradual = [1, 2, 4, 5, 9, 6, 4, 1, -1, -4, -5, -2, 1]

    assert Day2.dampened_gradual?(gradual)
  end

  test "Given a list of numbers where at most one adjacent pair is identical, when passed to dampened_gradual?, then true will be returned" do
    gradual = [1, 2, 4, 5, 8, 6, 4, 1, -1, -4, -4, -2, 1]

    assert Day2.dampened_gradual?(gradual)
  end

  test "Given a list of numbers where at least two adjacent pairs differ by more than 3, when passed to dampened_gradual?, then false will be returned" do
    gradual = [1, 2, 4, 5, 9, 5, 4, 1, -1, -4, -5, -2, 1]

    refute Day2.dampened_gradual?(gradual)
  end

  test "Given a list of numbers where at least two adjacent pairs are identical, when passed to dampened_gradual? then false will be returned" do
    gradual = [1, 2, 4, 4, 5, 5, 4, 1, -1, -4, -5, -2, 1]

    refute Day2.dampened_gradual?(gradual)
  end

  test "Given the sample input, when provided to test_dampened_reports then 4 reports will be found to be safe" do
    reports = [
      [7, 6, 4, 2, 1],
      [1, 2, 7, 8, 9],
      [9, 7, 6, 2, 1],
      [1, 3, 2, 4, 5],
      [8, 6, 4, 4, 1],
      [1, 3, 6, 7, 9]
    ]

    assert Day2.test_dampened_reports(reports) == 4
  end

  test "Given some list of one number, when provided to all_perms then an empty list will be returned." do
    single = [1]

    assert Day2.all_perms(single) == []
  end

  test "Given some list of two numbers, when provided to all_perms, then two lists of one number where each is one number in the input will be produced" do
    pair = [1, 2]

    sublists = Day2.all_perms(pair)

    assert length(sublists) == 2

    assert Enum.member?(sublists, [1])
    assert Enum.member?(sublists, [2])
  end

  test "Given some list of n numbers, when provided to all_perms, then n lists of n-1 numbers will be produced where each list contains all but one number from the input list" do
    report = [9, 7, 6, 2, 1]

    subreports = Day2.all_perms(report)

    assert length(subreports) == 5
    assert Enum.member?(subreports, [7, 6, 2, 1])
    assert Enum.member?(subreports, [9, 6, 2, 1])
    assert Enum.member?(subreports, [9, 7, 2, 1])
    assert Enum.member?(subreports, [9, 7, 6, 1])
    assert Enum.member?(subreports, [9, 7, 6, 2])
  end
end
