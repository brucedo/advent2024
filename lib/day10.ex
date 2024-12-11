defmodule Day10 do
  require Logger

  def run() do
    lines =
      Common.open(File.cwd(), "day10.txt")
      |> Common.read_file_pipe()
      |> Common.close()

    height = length(lines)
    width = String.length(List.first(lines))

    map_for_grid =
      Enum.with_index(lines)
      |> Enum.reduce(%{}, fn {string, row_index}, acc ->
        String.graphemes(string)
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {height, col_index}, acc ->
          Map.put(acc, %Point{x: col_index, y: row_index}, height)
        end)
      end)

    grid = %Grid{width: width, height: height, map: map_for_grid}
    trailheads = find_trailheads(grid)

    paths_to_peaks =
      Enum.map(trailheads, fn trailhead -> {trailhead, walk_path(grid, trailhead)} end)

    total_score =
      Enum.map(paths_to_peaks, fn {_, peaks} -> peaks end)
      |> Enum.map(&MapSet.new/1)
      |> Enum.map(&MapSet.size/1)
      |> Enum.sum()

    IO.puts("Total score might be #{inspect(total_score)}")

    multiwalk_score = Enum.map(trailheads, &multiwalk(grid, &1)) |> Enum.sum()

    IO.puts("Total multiwalk score? #{inspect(multiwalk_score)}")
  end

  def multiwalk(_grid, []) do
    0
  end

  def multiwalk(grid, head) do
    case Map.get(grid.map, head) == 9 do
      true ->
        1

      false ->
        find_steps(grid, head)
        |> Enum.map(&multiwalk(grid, &1))
        |> Enum.sum()
    end
  end

  def walk_path(_grid, []) do
    []
  end

  def walk_path(grid, head) do
    case Map.get(grid.map, head) == 9 do
      true ->
        [head]

      false ->
        for point <- find_steps(grid, head) do
          walk_path(grid, point)
        end
        |> List.flatten()
    end
  end

  @spec find_trailheads(%Grid{}) :: [%Point{}]
  def find_trailheads(grid) do
    Logger.debug("#{inspect(grid, limit: :infinity)}")

    Enum.filter(grid.map, fn {_key, value} -> value == 0 end)
    |> Enum.map(fn {key, _} -> key end)
  end

  @spec find_steps(%Grid{}, %Point{}) :: [%Point{}]
  def find_steps(grid, from_point) do
    left = %Point{x: from_point.x - 1, y: from_point.y}
    up = %Point{x: from_point.x, y: from_point.y - 1}
    right = %Point{x: from_point.x + 1, y: from_point.y}
    down = %Point{x: from_point.x, y: from_point.y + 1}

    current_height = Map.get(grid.map, from_point)

    [
      single_check(grid.map, left, current_height + 1),
      single_check(grid.map, up, current_height + 1),
      single_check(grid.map, right, current_height + 1),
      single_check(grid.map, down, current_height + 1)
    ]
    |> Enum.filter(&(&1 != nil))
  end

  defp single_check(map, point, required_height) do
    case Map.get(map, point) do
      nil ->
        nil

      height ->
        if height == required_height do
          point
        else
          nil
        end
    end
  end
end
