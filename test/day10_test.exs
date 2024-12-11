defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "Given some Point and a height map, when the the terrain at Point on the height map has one climbable neighbor, find_steps() will return a list of one" do
    grid_map = %Grid{
      width: 2,
      height: 2,
      map: %{
        %Point{x: 0, y: 0} => 4,
        %Point{x: 1, y: 0} => 6,
        %Point{x: 0, y: 1} => 5
      }
    }

    point = %Point{x: 0, y: 0}

    assert Day10.find_steps(grid_map, point) == [%Point{x: 0, y: 1}]
  end

  test "Given some Point and a height map, when the terrain at Point on the height map has 4 climbable neighbors, find_steps() will return a list of four" do
    grid_map = %Grid{
      width: 3,
      height: 3,
      map: %{
        %Point{x: 1, y: 1} => 6,
        %Point{x: 0, y: 1} => 7,
        %Point{x: 2, y: 1} => 7,
        %Point{x: 1, y: 0} => 7,
        %Point{x: 1, y: 2} => 7
      }
    }

    point = %Point{x: 1, y: 1}
    found_paths = Day10.find_steps(grid_map, point)
    assert Enum.member?(found_paths, %Point{x: 0, y: 1})
    assert Enum.member?(found_paths, %Point{x: 2, y: 1})
    assert Enum.member?(found_paths, %Point{x: 1, y: 0})
    assert Enum.member?(found_paths, %Point{x: 1, y: 2})
  end

  test "Given some Point and a height map, when the terrain at Point on the height map has 0 climbable neighbors, find_steps() will return an empty list" do
    grid_map = %Grid{
      width: 3,
      height: 3,
      map: %{
        %Point{x: 1, y: 1} => 6,
        %Point{x: 0, y: 1} => 1,
        %Point{x: 2, y: 1} => 2,
        %Point{x: 1, y: 0} => 8,
        %Point{x: 1, y: 2} => 9
      }
    }

    point = %Point{x: 1, y: 1}

    assert Day10.find_steps(grid_map, point) == []
  end

  test "Given some grid with one height 0 cell, find_trailheads() will return a list with one element" do
    grid_map = %Grid{
      width: 3,
      height: 3,
      map: %{
        %Point{x: 1, y: 1} => 6,
        %Point{x: 0, y: 1} => 0,
        %Point{x: 2, y: 1} => 2,
        %Point{x: 1, y: 0} => 8,
        %Point{x: 1, y: 2} => 9
      }
    }

    assert Day10.find_trailheads(grid_map) == [%Point{x: 0, y: 1}]
  end

  test "Given some grid with 4 cells with 0 height, find_trailheads() will return a list with 4 elements" do
    grid_map = %Grid{
      width: 3,
      height: 3,
      map: %{
        %Point{x: 1, y: 1} => 0,
        %Point{x: 0, y: 1} => 0,
        %Point{x: 2, y: 1} => 2,
        %Point{x: 1, y: 0} => 0,
        %Point{x: 1, y: 2} => 0
      }
    }

    trailheads = Day10.find_trailheads(grid_map)

    assert length(trailheads) == 4
    assert Enum.member?(trailheads, %Point{x: 1, y: 1})
    assert Enum.member?(trailheads, %Point{x: 0, y: 1})
    assert Enum.member?(trailheads, %Point{x: 1, y: 0})
    assert Enum.member?(trailheads, %Point{x: 1, y: 2})
  end
end
