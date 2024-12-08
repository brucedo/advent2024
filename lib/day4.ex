defmodule Day4 do
  require Logger

  def run() do
    lines =
      Common.open(File.cwd(), "day4.txt") |> Common.read_file_pipe() |> Common.close()

    height = length(lines)
    width = Enum.map(lines, fn line -> String.length(line) end) |> Enum.max()

    Logger.debug("Computed height and width: #{height}x#{width}")

    pre_grid =
      Enum.with_index(lines)
      |> Enum.map(fn {text, index} -> {indexer(text), index} end)
      |> Enum.map(fn {indexed_list, index} -> pointifier(indexed_list, index) end)
      |> Enum.flat_map(fn point -> point end)
      |> Enum.reduce(%{}, fn {point, letter}, acc -> Map.put(acc, point, letter) end)

    # Logger.debug("Computed map: #{pre_grid}")

    grid = %Grid{width: width, height: height, map: pre_grid}

    appearances = word_count(grid)

    IO.puts("Total count of appearances of XMAS: #{appearances}")

    cross_appearances = cross_word_count(grid)
    IO.puts("Total count of appearances of MAS in X: #{cross_appearances}")
  end

  @spec cross_word_count(%Grid{}) :: integer()
  def cross_word_count(grid) do
    up_left = %Point{x: -1, y: -1}
    down_right = %Point{x: 1, y: 1}

    up_right = %Point{x: 1, y: -1}
    down_left = %Point{x: -1, y: 1}

    starting_points =
      Enum.filter(grid.map, fn {_, letter} -> letter == "A" end)
      |> Enum.map(fn {point, _} -> point end)

    Enum.map(starting_points, fn a_point ->
      {
        %Point{x: a_point.x + up_left.x, y: a_point.y + up_left.y},
        %Point{x: a_point.x + down_right.x, y: a_point.y + down_right.y},
        %Point{x: a_point.x + up_right.x, y: a_point.y + up_right.y},
        %Point{x: a_point.x + down_left.x, y: a_point.y + down_left.y}
      }
    end)
    |> Enum.map(fn {up_left, down_right, up_right, down_left} ->
      {
        (letter_check(grid, up_left, "S") && letter_check(grid, down_right, "M")) ||
          (letter_check(grid, up_left, "M") && letter_check(grid, down_right, "S")),
        (letter_check(grid, up_right, "S") && letter_check(grid, down_left, "M")) ||
          (letter_check(grid, up_right, "M") && letter_check(grid, down_left, "S"))
      }
    end)
    |> Enum.map(fn {right_diagonal, left_diagonal} -> right_diagonal && left_diagonal end)
    |> Enum.filter(fn t -> t end)
    |> Enum.count()
  end

  @spec word_count(%Grid{}) :: integer()
  def word_count(grid) do
    target = ["X", "M", "A", "S"]

    directions = [
      %Point{x: 1, y: 1},
      %Point{x: 1, y: 0},
      %Point{x: 1, y: -1},
      %Point{x: 0, y: -1},
      %Point{x: -1, y: -1},
      %Point{x: -1, y: 0},
      %Point{x: -1, y: 1},
      %Point{x: 0, y: 1}
    ]

    starting_points =
      Enum.filter(grid.map, fn {_, letter} -> letter == List.first(target) end)
      |> Enum.map(fn {point, _} -> point end)

    Enum.map(starting_points, fn point ->
      for direction <- directions do
        scan(grid, point, direction, target)
      end
    end)
    |> Enum.flat_map(fn t -> t end)
    |> Enum.filter(fn t -> t end)
    |> Enum.count()
  end

  @spec scan(%Grid{}, %Point{}, %Point{}, list(String.t())) :: boolean()
  def scan(_, _, _, []) do
    true
  end

  def scan(grid, cell, direction, [letter | rest]) do
    case letter_check(grid, cell, letter) do
      true ->
        scan(grid, %Point{x: cell.x + direction.x, y: cell.y + direction.y}, direction, rest)

      a ->
        a
    end
  end

  @spec letter_check(%Grid{}, %Point{}, String.t()) :: boolean()
  def letter_check(grid, point, wanted) do
    if(point.x >= grid.width || point.y >= grid.height) do
      false
    else
      Map.get(grid.map, point) == wanted
    end
  end

  @spec indexer(String.t()) :: list({String.t(), integer()})
  def indexer(letter_sequence) do
    String.splitter(letter_sequence, "")
    |> Enum.filter(fn letter -> letter != "" end)
    |> Enum.with_index()
  end

  @spec pointifier(list({String.t(), integer()}), integer()) :: list({%Point{}, String.t()})
  def pointifier([], _) do
    []
  end

  def pointifier([{letter, column} | character_map], row_number) do
    [{%Point{x: column, y: row_number}, letter} | pointifier(character_map, row_number)]
  end
end
