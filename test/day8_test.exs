defmodule Day8Test do
  require Logger
  use ExUnit.Case
  doctest Day8

  test "Given some pair of Points, find_slope will return the integer {rise, run} pair of the slope of the two points" do
    one = %Point{x: 5, y: 2}
    two = %Point{x: 7, y: 3}

    assert Day8.find_slope(one, two) == {1, 2}
  end

  test "Given some pair of Points where point one is to the right of point 2, find_slope will return an integer {rise, -run} pair" do
    one = %Point{x: 7, y: 3}
    two = %Point{x: 4, y: 4}

    assert Day8.find_slope(one, two) == {1, -3}
  end

  test "Given some pair of Points where point one is below and to the right of point 2, find_slope will return an integer {-rise, -run} pair" do
    one = %Point{x: 8, y: 8}
    two = %Point{x: 6, y: 5}

    assert Day8.find_slope(one, two) == {-3, -2}
  end

  test "Given some pair of Points and their slope, find_antinodes will produce a pair of points that are the antinodes of the pair" do
    one = %Point{x: 5, y: 2}
    two = %Point{x: 7, y: 3}
    slope = {1, 2}

    antinodes = Day8.find_antinodes(one, two, slope) |> Tuple.to_list()

    assert length(antinodes) == 2
    assert Enum.member?(antinodes, %Point{x: 3, y: 1})
    assert Enum.member?(antinodes, %Point{x: 9, y: 4})
  end

  test "Given some pair of in opposite order than the definition of the slope, find_antinodes will produce a pair of points at the antinodes of the pair" do
    one = %Point{x: 5, y: 2}
    two = %Point{x: 7, y: 3}
    slope = {1, 2}

    antinodes = Day8.find_antinodes(two, one, slope) |> Tuple.to_list()

    assert length(antinodes) == 2
    assert Enum.member?(antinodes, %Point{x: 3, y: 1})
    assert Enum.member?(antinodes, %Point{x: 9, y: 4})
  end

  test "Given some Point, a slope and a boundary condition find_all_antinodes will produce a list of Points whose x coordinates never recede below 0" do
    start = %Point{x: 5, y: 2}
    slope = {1, 2}
    boundary = {10, 10}

    antinodes = Day8.find_all_antinodes(start, slope, boundary)

    assert Enum.all?(antinodes, fn point -> point.x >= 0 end)
  end

  test "Given some Point, a slope and a boundary condition find_all_antinodes will produce a list of Points whose y coordinates never recede below 0" do
    start = %Point{x: 5, y: 2}
    slope = {1, 2}
    boundary = {10, 10}

    antinodes = Day8.find_all_antinodes(start, slope, boundary)

    assert Enum.all?(antinodes, fn point -> point.y >= 0 end)
  end

  test "Given some Point, a slope and a {boundary_x, boundary_y} conditon find_all_antinodes will produce a lsit of Points whose x coordinates never equal or exceed boundary_x" do
    start = %Point{x: 5, y: 2}
    slope = {1, 1}
    boundary = {10, 10}

    antinodes = Day8.find_all_antinodes(start, slope, boundary)

    assert Enum.all?(antinodes, fn point -> point.x < boundary end)
  end

  test "Given some Point, a slope anda {boundary_x, boundary_y} condition find_all_antinodes will produce a list of Points whose y coordinates never equal or exceed boundary_y" do
    start = %Point{x: 5, y: 2}
    slope = {2, 1}
    boundary = {10, 10}

    antinodes = Day8.find_all_antinodes(start, slope, boundary)

    assert Enum.all?(antinodes, fn point -> point.y < boundary end)
  end

  test "Given some Point{x, y}, a slope{rise, run} and a boundary condition find_all_antinodes will produce a list of Points whose x coordinates are all {x + c * run}" do
    start = %Point{x: 5, y: 2}
    slope = {2, 1}
    boundary = {10, 10}

    c =
      Day8.find_all_antinodes(start, slope, boundary)
      |> Enum.map(& &1.x)
      |> Enum.map(&abs(&1))
      |> Enum.map(fn x_prime -> (x_prime - start.x) / elem(slope, 1) end)

    assert Enum.all?(c, &(&1 == floor(&1)))
  end

  test "Given some Point {x, y} a slope{rise, run} and a boundary condition find_all_antinodes will produce a list of Points whose y coordinates are all {y + c * rise}" do
    start = %Point{x: 5, y: 2}
    slope = {2, 1}
    boundary = {10, 10}

    c =
      Day8.find_all_antinodes(start, slope, boundary)
      |> Enum.map(& &1.y)
      |> Enum.map(&abs/1)
      |> Enum.map(fn y_prime -> (y_prime - start.y) / elem(slope, 0) end)

    Logger.debug("#{inspect(c)}")

    assert Enum.all?(c, &(&1 == floor(&1)))
  end

  test "Failing pair 8, 8,  and 9, 9" do
    start = %Point{x: 8, y: 8}
    slope = {1, 1}
    boundary = {12, 12}

    c = Day8.find_all_antinodes(start, slope, boundary)

    IO.puts("#{inspect(c)}")
  end
end
