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

  test "Given a tuple {[letters], row_index} then pointifier() will construct a [{Point, letter}]" do
    list = [{"X", 0}, {"M", 1}, {"I", 2}, {"S", 3}, {"S", 4}]

    assert Day4.pointifier(list, 1) == [
             {%Point{x: 0, y: 1}, "X"},
             {%Point{x: 1, y: 1}, "M"},
             {%Point{x: 2, y: 1}, "I"},
             {%Point{x: 3, y: 1}, "S"},
             {%Point{x: 4, y: 1}, "S"}
           ]
  end

  test "Given a Grid with the letter 'X' at %Point{x:1, y:1} then letter_check(Grid, Point, 'X') will return true " do
    grid = %Grid{
      width: 2,
      height: 2,
      map: %{%Point{x: 0, y: 0} => "M", %Point{x: 1, y: 1} => "X"}
    }

    assert Day4.letter_check(grid, %Point{x: 1, y: 1}, "X")
  end

  test "Given a Grid with the letter 'X' at %Point{x: 0, y: 0} then letter_check(Grid, %Point{x: 1, y: 1}, 'X') will return false" do
    grid = %Grid{
      width: 2,
      height: 2,
      map: %{%Point{x: 0, y: 0} => "X", %Point{x: 1, y: 1} => "M"}
    }

    refute Day4.letter_check(grid, %Point{x: 1, y: 1}, "X")
  end

  test "Given a Grid with width 2, when letter_check is provided a point with x = 2, then it will return false" do
    grid = %Grid{
      width: 2,
      height: 2,
      map: %{%Point{x: 0, y: 0} => "M", %Point{x: 2, y: 1} => "X"}
    }

    refute Day4.letter_check(grid, %Point{x: 2, y: 1}, "X")
  end

  test "Given a Grid with height 2, when letter_check is provided with a point with y = 2, then it will return false" do
    grid = %Grid{
      width: 2,
      height: 2,
      map: %{%Point{x: 0, y: 0} => "M", %Point{x: 1, y: 2} => "X"}
    }

    refute Day4.letter_check(grid, %Point{x: 1, y: 2}, "X")
  end

  test "Given a grid with XMAS written diagonally, a starting point of 0, 0, a direction of 1, 1, and text list ['X', 'M', 'A', 'S'] then scan will return true" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 0, y: 0} => "X",
        %Point{x: 1, y: 1} => "M",
        %Point{x: 2, y: 2} => "A",
        %Point{x: 3, y: 3} => "S"
      }
    }

    assert Day4.scan(grid, %Point{x: 0, y: 0}, %Point{x: 1, y: 1}, ["X", "M", "A", "S"])
  end

  test "Given a grid with XMAS written up-left, a starting point of 0, 0, a direction of 1, 1 and text list ['X', 'M', 'A', 'S'] then the scan will return false" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 3, y: 3} => "X",
        %Point{x: 2, y: 2} => "M",
        %Point{x: 1, y: 1} => "A",
        %Point{x: 0, y: 0} => "S"
      }
    }

    refute Day4.scan(grid, %Point{x: 0, y: 0}, %Point{x: 1, y: 1}, ["X", "M", "A", "S"])
  end

  test "Given a grid with XMAS written down-right, a starting point of 0, 0, a direction of -1, -1 and a text list ['S', 'A', 'M', 'X'] then scan will return true" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 0, y: 0} => "X",
        %Point{x: 1, y: 1} => "M",
        %Point{x: 2, y: 2} => "A",
        %Point{x: 3, y: 3} => "S"
      }
    }

    assert Day4.scan(grid, %Point{x: 3, y: 3}, %Point{x: -1, y: -1}, ["S", "A", "M", "X"])
  end

  test "Given a grid of Point -> letter containing XMAS, word_count() will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 0, y: 0} => "X",
        %Point{x: 1, y: 0} => "M",
        %Point{x: 2, y: 0} => "A",
        %Point{x: 3, y: 0} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end

  test "Given a grid of Point -> letter containing SAMX, word_count() will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 3, y: 0} => "X",
        %Point{x: 2, y: 0} => "M",
        %Point{x: 1, y: 0} => "A",
        %Point{x: 0, y: 0} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end

  test "Given a grid of Point -> letter containing XMAS written down vertically, word_count()will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 0, y: 0} => "X",
        %Point{x: 0, y: 1} => "M",
        %Point{x: 0, y: 2} => "A",
        %Point{x: 0, y: 3} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end

  test "Given a grid of Point -> letter containing xmas written up vertically, word_count()will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 0, y: 3} => "X",
        %Point{x: 0, y: 2} => "M",
        %Point{x: 0, y: 1} => "A",
        %Point{x: 0, y: 0} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end

  test "Given a grid of Point -> letter containing xmas written diagonally down-left, word_count()will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 3, y: 0} => "X",
        %Point{x: 2, y: 1} => "M",
        %Point{x: 1, y: 2} => "A",
        %Point{x: 0, y: 3} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end

  test "Given a grid of point -> letter containing xmas written diagonally down-right, word_count()will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 0, y: 0} => "X",
        %Point{x: 1, y: 1} => "M",
        %Point{x: 2, y: 2} => "A",
        %Point{x: 3, y: 3} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end

  test "Given a grid of point -> letter containing xmas written diagonally up-right, word_count()will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 0, y: 3} => "X",
        %Point{x: 1, y: 2} => "M",
        %Point{x: 2, y: 1} => "A",
        %Point{x: 3, y: 0} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end

  test "Given a grid of point -> letter containing xmas written diagonally up-left, word_count()will return 1" do
    grid = %Grid{
      width: 4,
      height: 4,
      map: %{
        %Point{x: 3, y: 3} => "X",
        %Point{x: 2, y: 2} => "M",
        %Point{x: 1, y: 1} => "A",
        %Point{x: 0, y: 0} => "S"
      }
    }

    assert Day4.word_count(grid) == 1
  end
end
