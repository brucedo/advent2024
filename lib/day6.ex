defmodule Guard do
  defstruct position: %Point{x: 0, y: 0}, facing: :up
end

defmodule Day6 do
  require Logger

  def run() do
    lines =
      Common.open(File.cwd(), "day6.txt") |> Common.read_file_pipe() |> Common.close()

    height = length(lines)
    width = String.length(List.first(lines))

    grid_map =
      Enum.with_index(lines)
      |> Enum.reduce(Map.new(), fn {string, index}, acc -> map_from_line(string, acc, index) end)

    grid = %Grid{width: width, height: height, map: grid_map}
    guard = find_guard(lines)

    finished_grid = walk_the_guard(guard, grid)

    count =
      Enum.map(finished_grid.map, fn {_point, status} -> status end)
      |> Enum.filter(fn status -> status == :visited end)
      |> Enum.count()

    IO.puts("#{inspect(count)} cells visited")

    walked_cells =
      Enum.filter(finished_grid.map, fn {_point, status} -> status == :visited end)
      |> Enum.map(fn {point, _} -> point end)

    possible_blocking_positiongs = modified_walkies(grid, guard, walked_cells)

    IO.puts("???????#{inspect(possible_blocking_positiongs)}??????")

    IO.puts(
      "Total count of blocking positions: #{inspect(Enum.count(possible_blocking_positiongs))}"
    )
  end

  @spec walk_the_guard(%Guard{}, %Grid{}) :: %Grid{}
  defp walk_the_guard(%Guard{position: _, facing: :departed}, grid) do
    grid
  end

  defp walk_the_guard(guard, grid) do
    {grid, guard} = advance(grid, guard)
    walk_the_guard(guard, grid)
  end

  defp find_guard(list) do
    find_guard(list, 0)
  end

  defp find_guard([], _) do
    {}
  end

  defp find_guard([line | rest], index) do
    case find_guard_in_line(line) do
      {} ->
        find_guard(rest, index + 1)

      {char, char_index} ->
        %Guard{position: %Point{x: char_index, y: index}, facing: facing_from_char(char)}
    end
  end

  defp find_guard_in_line(line) do
    find_guard_in_line(String.to_charlist(line), 0)
  end

  defp find_guard_in_line([], _) do
    {}
  end

  defp find_guard_in_line([curr_char | rest_chars], column_index) do
    if curr_char != ?# && curr_char != ?. do
      {curr_char, column_index}
    else
      find_guard_in_line(rest_chars, column_index + 1)
    end
  end

  defp map_from_line(line, map, index) do
    String.to_charlist(line)
    |> Enum.map(fn char ->
      if char == ?# do
        :filled
      else
        :empty
      end
    end)
    |> Enum.with_index()
    |> Enum.reduce(map, fn {cell_contents, char_index}, map ->
      Map.put(
        map,
        %Point{x: char_index, y: index},
        cell_contents
      )
    end)
  end

  @spec modified_walkies(%Grid{}, %Guard{}, list(%Point{})) :: list(%Point{})
  def modified_walkies(_grid, _guard, []) do
    []
  end

  def modified_walkies(grid, guard, [next_block_point | possible_block_points]) do
    # {grid, guard} = modified_advance(grid, guard)

    # Logger.debug(
    #   "Guard advanced to position #{inspect(guard.position)}, facing #{inspect(guard.facing)}"
    # )
    #
    simulated_blockage = %Grid{
      width: grid.width,
      height: grid.height,
      map: Map.replace(grid.map, next_block_point, :filled)
    }

    case simulated_walk(simulated_blockage, guard) do
      true -> [next_block_point | modified_walkies(grid, guard, possible_block_points)]
      false -> modified_walkies(grid, guard, possible_block_points)
    end
  end

  @spec simulated_walk(%Grid{}, %Guard{}) :: boolean()
  def simulated_walk(_grid, %Guard{position: _, facing: :departed}) do
    false
  end

  def simulated_walk(grid, guard) do
    current_cell_visited = Map.get(grid.map, guard.position)

    case current_cell_visited == guard.facing do
      true ->
        true

      false ->
        {grid, guard} = modified_advance(grid, guard)

        simulated_walk(grid, guard)
    end
  end

  @spec modified_advance(%Grid{}, %Guard{}) :: {%Grid{}, %Guard{}}
  def modified_advance(grid, guard) do
    guard_target = new_point_from_facing(guard.position, guard.facing)

    case Map.get(grid.map, guard_target) do
      x when x in [:up, :down, :left, :right] ->
        {
          grid,
          %Guard{position: guard_target, facing: guard.facing}
        }

      :empty ->
        {%Grid{
           width: grid.width,
           height: grid.height,
           map: Map.replace(grid.map, guard.position, guard.facing)
         }, %Guard{position: guard_target, facing: guard.facing}}

      :filled ->
        {
          grid,
          %Guard{position: guard.position, facing: rotate_right(guard.facing)}
        }

      nil ->
        {%Grid{
           width: grid.width,
           height: grid.height,
           map: Map.replace(grid.map, guard.position, guard.facing)
         }, %Guard{position: guard_target, facing: :departed}}
    end
  end

  @spec advance(%Grid{}, %Guard{}) :: {%Grid{}, %Guard{}}
  def advance(grid, guard) do
    guard_target = new_point_from_facing(guard.position, guard.facing)

    case Map.get(grid.map, guard_target) do
      x when x in [:empty, :visited] ->
        {%Grid{
           width: grid.width,
           height: grid.height,
           map: Map.replace(grid.map, guard.position, :visited)
         }, %Guard{position: guard_target, facing: guard.facing}}

      :filled ->
        {grid, %Guard{position: guard.position, facing: rotate_right(guard.facing)}}

      nil ->
        {%Grid{
           width: grid.width,
           height: grid.height,
           map: Map.replace(grid.map, guard.position, :visited)
         }, %Guard{position: guard_target, facing: :departed}}
    end
  end

  defp rotate_right(facing) do
    case facing do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  defp facing_from_char(char) do
    case char do
      ?^ -> :up
      ?> -> :right
      ?< -> :left
      ?v -> :down
    end
  end

  defp new_point_from_facing(point, facing) do
    facing_offset =
      case facing do
        :up -> %Point{x: 0, y: -1}
        :down -> %Point{x: 0, y: 1}
        :left -> %Point{x: -1, y: 0}
        :right -> %Point{x: 1, y: 0}
      end

    %Point{x: point.x + facing_offset.x, y: point.y + facing_offset.y}
  end
end
