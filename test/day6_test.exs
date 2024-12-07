defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "Given a Guard pointing up, and a Grid with an empty space above the guard, then advance() will update the guard to the next row up" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: -1} => :empty}
    }

    guard = %Guard{facing: :up, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: 0, y: -1}
  end

  test "Given a Guard pointing up and a Grid with an empty space above the guard, then advance() will modify the Grid at the old Guard position to :visited" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: -1} => :empty}
    }

    guard = %Guard{facing: :up, position: %Point{x: 0, y: 0}}

    {grid, _} = Day6.advance(grid, guard)

    assert Map.get(grid.map, %Point{x: 0, y: 0}) == :visited
  end

  test "Given a Guard facing up and a Grid with a filled space above the guard, then advance() will rotate the guard to face right" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: -1} => :filled}
    }

    guard = %Guard{facing: :up, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: 0, y: 0}
    assert guard.facing == :right
  end

  test "Given a Guard pointing left and a Grid with an empty space left of the guard, then advance() will update the guard to the next column left" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: -1, y: 0} => :empty}
    }

    guard = %Guard{facing: :left, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: -1, y: 0}
  end

  test "Given a Guard pointing left and a Grid with an empty space left of the guard, then advance() will modify the Grid at the old Guard position to :visited" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: -1, y: 0} => :empty}
    }

    guard = %Guard{facing: :left, position: %Point{x: 0, y: 0}}

    {grid, _} = Day6.advance(grid, guard)

    assert Map.get(grid.map, %Point{x: 0, y: 0}) == :visited
  end

  test "Given a Guard facing left and a Grid with a filled space left of the guard, then advance will rotate the guard to face up" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: -1, y: 0} => :filled}
    }

    guard = %Guard{facing: :left, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: 0, y: 0}
    assert guard.facing == :up
  end

  test "Given a Guard pointing right and a Grid with an empty space right of the guard, then advance() will update the guard to the next column right" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 1, y: 0} => :empty}
    }

    guard = %Guard{facing: :right, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: 1, y: 0}
  end

  test "Given a Guard facing right and a Grid with an empty space right of the guard, then advance(0 will modify the Grid at the old Guard position to :visited" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 1, y: 0} => :empty}
    }

    guard = %Guard{facing: :right, position: %Point{x: 0, y: 0}}

    {grid, _} = Day6.advance(grid, guard)

    assert Map.get(grid.map, %Point{x: 0, y: 0}) == :visited
  end

  test "Given a Guard facing right and a Grid with a filled space right of the guard, then advance() will rotate the guard to face down" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 1, y: 0} => :filled}
    }

    guard = %Guard{facing: :right, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: 0, y: 0}
    assert guard.facing == :down
  end

  test "Given a Guard pointing down and a Grid with an empty space below the guard, then advance() will update the guard to the next row down" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: 1} => :empty}
    }

    guard = %Guard{facing: :down, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: 0, y: 1}
  end

  test "Given a Guard facing down anda  Grid with an empty space below the guard, then advance() will modify the Grid at the old Guard position to :visited" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: 1} => :empty}
    }

    guard = %Guard{facing: :down, position: %Point{x: 0, y: 0}}

    {grid, _} = Day6.advance(grid, guard)

    assert Map.get(grid.map, %Point{x: 0, y: 0}) == :visited
  end

  test "Given a Guard pointing down and a Grid with an filled space below the guard, then advance() will update the guard to face left" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: 1} => :filled}
    }

    guard = %Guard{facing: :down, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.position == %Point{x: 0, y: 0}
    assert guard.facing == :left
  end

  test "Given a Guard facing up and seated on the top of the map, then advance() will set the Guard facing to :departed" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: 1} => :filled}
    }

    guard = %Guard{facing: :up, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.facing == :departed
  end

  test "Given a Guard facing left and seated on the left of the map, then advance() will set the Guard facing to :departed" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 1, y: 0} => :filled}
    }

    guard = %Guard{facing: :left, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.facing == :departed
  end

  test "Given a Guard facing right and seated on the right edge of the map, then advance() will set the Guard facing to :departed" do
    grid = %Grid{
      width: 2,
      height: 1,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: -1, y: 0} => :filled}
    }

    guard = %Guard{facing: :right, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.facing == :departed
  end

  test "Given a Guard facing down and seated on the bottom row of the map, then advance() will set the Guard facing to :departed" do
    grid = %Grid{
      width: 1,
      height: 2,
      map: %{%Point{x: 0, y: 0} => :empty, %Point{x: 0, y: -1} => :filled}
    }

    guard = %Guard{facing: :down, position: %Point{x: 0, y: 0}}

    {_, guard} = Day6.advance(grid, guard)

    assert guard.facing == :departed
  end
end
