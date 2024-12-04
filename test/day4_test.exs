defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "Given some list of letters, indexer() will return a list of tuples of the form {letter, index}" do
    jumble = "abcdepoopy"

    assert Day4.indexer(jumble) == [
             {"a", 0},
             {"b", 1},
             {"c", 2},
             {"d", 3},
             {"e", 4},
             {"p", 5},
             {"o", 6},
             {"o", 7},
             {"p", 8},
             {"y", 9}
           ]
  end

  test "Given some list of tuples of the form {letter, index} and the current row number, gridifier() will return a Map of Point->letter" do
    tuple_list = [{"X", 0}, {"M", 1}, {"I", 2}, {"S", 3}, {"S", 4}]

    assert Day4.gridifier(tuple_list, 1) == %{
             %Point{x: 0, y: 1} => "X",
             %Point{x: 1, y: 1} => "M",
             %Point{x: 2, y: 1} => "I",
             %Point{x: 3, y: 1} => "S",
             %Point{x: 4, y: 1} => "S"
           }
  end

  test "Given a grid of Point -> letter containing XMAS, word_count() will return 1" do
    grid = %{
      %Point{x: 0, y: 0} => "X",
      %Point{x: 1, y: 0} => "M",
      %Point{x: 2, y: 0} => "A",
      %Point{x: 3, y: 0} => "S"
    }

    assert Day4.word_count(grid, 4, 1) == 1
  end

  test "Given a grid of Point -> letter containing SAMX, word_count() will return 1" do
    grid = %{
      %Point{x: 3, y: 0} => "X",
      %Point{x: 2, y: 0} => "M",
      %Point{x: 1, y: 0} => "A",
      %Point{x: 0, y: 0} => "S"
    }

    assert Day4.word_count(grid, 4, 1) == 1
  end

  test "Given a grid of Point -> letter containing XMAS written down vertically, word_count()will return 1" do
    grid = %{
      %Point{x: 0, y: 0} => "X",
      %Point{x: 0, y: 1} => "M",
      %Point{x: 0, y: 2} => "A",
      %Point{x: 0, y: 3} => "S"
    }

    assert Day4.word_count(grid, 1, 4) == 1
  end

  test "Given a grid of Point -> letter containing xmas written up vertically, word_count()will return 1" do
    grid = %{
      %Point{x: 0, y: 3} => "X",
      %Point{x: 0, y: 2} => "M",
      %Point{x: 0, y: 1} => "A",
      %Point{x: 0, y: 0} => "S"
    }

    assert Day4.word_count(grid, 1, 4) == 1
  end

  test "Given a grid of Point -> letter containing xmas written diagonally down-left, word_count()will return 1" do
    grid = %{
      %Point{x: 3, y: 0} => "X",
      %Point{x: 2, y: 1} => "M",
      %Point{x: 1, y: 2} => "A",
      %Point{x: 0, y: 3} => "S"
    }

    assert Day4.word_count(grid, 4, 4) == 1
  end

  test "Given a grid of point -> letter containing xmas written diagonally down-right, word_count()will return 1" do
    grid = %{
      %Point{x: 0, y: 0} => "X",
      %Point{x: 1, y: 1} => "M",
      %Point{x: 2, y: 2} => "A",
      %Point{x: 3, y: 3} => "S"
    }

    assert Day4.word_count(grid, 4, 4) == 1
  end

  test "Given a grid of point -> letter containing xmas written diagonally up-right, word_count()will return 1" do
    grid = %{
      %Point{x: 0, y: 3} => "X",
      %Point{x: 1, y: 2} => "M",
      %Point{x: 2, y: 1} => "A",
      %Point{x: 3, y: 0} => "S"
    }

    assert Day4.word_count(grid, 4, 4) == 1
  end

  test "Given a grid of point -> letter containing xmas written diagonally up-left, word_count()will return 1" do
    grid = %{
      %Point{x: 3, y: 3} => "X",
      %Point{x: 2, y: 2} => "M",
      %Point{x: 1, y: 1} => "A",
      %Point{x: 0, y: 0} => "S"
    }

    assert Day4.word_count(grid, 4, 4) == 1
  end
end
