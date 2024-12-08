defmodule Day8 do
  require Logger

  def run do
    lines =
      Common.open(File.cwd(), "day8.txt") |> Common.read_file_pipe() |> Common.close()

    height = length(lines)
    width = String.length(List.first(lines))

    grid_map =
      Enum.with_index(lines)
      |> Enum.reduce(Map.new(), fn {string, index}, acc -> map_from_line(string, acc, index) end)

    antenna_to_point =
      Enum.filter(grid_map, fn {_point, element} -> element != ?. end)
      |> Enum.reduce(%{}, fn {point, antenna}, acc ->
        elem(
          Map.get_and_update(acc, antenna, fn value ->
            {value,
             if value == nil do
               [point]
             else
               [point | value]
             end}
          end),
          1
        )
      end)

    antinodes =
      Enum.map(antenna_to_point, fn {_antenna_name, antennas} -> all_antinodes(antennas) end)
      |> List.flatten()

    Logger.debug("#{inspect(antinodes, limit: :infinity)}")

    antinodes_in_map =
      Enum.reduce(antinodes, grid_map, fn antinode_point, acc ->
        Map.replace(acc, antinode_point, :antinode)
      end)
      |> Enum.filter(fn {_point, type} -> type == :antinode end)

    Logger.debug("#{inspect(antinodes_in_map, limit: :infinity)}")

    IO.puts(
      "well if this worked then there are #{inspect(length(antinodes_in_map))} within the map area."
    )

    multiple_antennas =
      Enum.filter(antenna_to_point, fn {_point, antennas} -> length(antennas) > 1 end)

    boundary = {width, height}

    # [_ | [a_antenna_only | []]] = Enum.map(multiple_antennas, &elem(&1, 1))
    #
    # whats_going_on_here = more_all_antinodes(a_antenna_only, boundary)
    # Logger.debug("What's going on here: #{inspect(whats_going_on_here)}")

    all_antinodes =
      Enum.map(multiple_antennas, &elem(&1, 1))
      |> Enum.map(fn antenna_list -> more_all_antinodes(antenna_list, boundary) end)
      |> List.flatten()

    # temp_map =
    #   Enum.reduce(all_antinodes, grid_map, fn antinode_point, acc ->
    #     Map.replace(acc, antinode_point, "#")
    #   end)

    # Common.visualize_map(temp_map, fn a -> a end, width, height)
    # |> Enum.each(fn line -> Logger.debug(line) end)

    deduped_antinodes = MapSet.new(all_antinodes)

    IO.puts(
      "If part 2 went well then there are #{inspect(MapSet.size(deduped_antinodes))} within the map area."
    )
  end

  @spec all_antinodes(list(%Point{})) :: list(%Point{})
  def all_antinodes([_ | []]) do
    []
  end

  def all_antinodes([next_antenna | rest]) do
    pairwise_antinodes(next_antenna, rest) ++ all_antinodes(rest)
  end

  @spec pairwise_antinodes(%Point{}, list(%Point{})) :: list(%Point{})
  defp pairwise_antinodes(_, []) do
    []
  end

  defp pairwise_antinodes(start_antenna, [next_antenna | rest]) do
    slope = find_slope(start_antenna, next_antenna)
    {antinode1, antinode2} = find_antinodes(start_antenna, next_antenna, slope)

    [antinode1 | [antinode2 | pairwise_antinodes(start_antenna, rest)]]
  end

  def map_from_line(line, dest_map, index) do
    String.to_charlist(line)
    |> Enum.with_index()
    # |> Enum.filter(fn {antenna_name, _index} -> antenna_name != ?. end)
    |> Enum.map(fn {indicator, column_index} -> {indicator, %Point{x: column_index, y: index}} end)
    |> Enum.reduce(dest_map, fn {indicator, point}, acc -> Map.put(acc, point, indicator) end)
  end

  @spec find_slope(%Point{}, %Point{}) :: {integer(), integer()}
  def find_slope(one, two) do
    {two.y - one.y, two.x - one.x}
  end

  @spec find_antinodes(%Point{}, %Point{}, {integer(), integer()}) :: {%Point{}, %Point{}}
  def find_antinodes(one, two, {rise, run}) do
    {one, two} =
      case one.x + run == two.x && one.y + rise == two.y do
        true -> {one, two}
        false -> {two, one}
      end

    {%Point{x: one.x - run, y: one.y - rise}, %Point{x: two.x + run, y: two.y + rise}}
  end

  @spec find_all_antinodes(%Point{}, {integer(), integer()}, {integer(), integer()}) ::
          list(%Point{})
  def find_all_antinodes(start, slope, boundary) do
    traverse_directional_slope(start, slope, boundary, &-/2) ++
      traverse_directional_slope(start, slope, boundary, &+/2)
  end

  defp traverse_directional_slope(prev, {rise, run}, {boundary_x, boundary_y}, op) do
    next = %Point{x: op.(prev.x, run), y: op.(prev.y, rise)}

    case next.x < 0 || next.y < 0 || next.x >= boundary_x || next.y >= boundary_y do
      true ->
        []

      false ->
        [next | traverse_directional_slope(next, {rise, run}, {boundary_x, boundary_y}, op)]
    end
  end

  @spec more_all_antinodes(list(%Point{}), {integer(), integer()}) :: list(%Point{})
  def more_all_antinodes([_ | []], _) do
    # Logger.debug("Out of antennas to inspect.")
    []
  end

  def more_all_antinodes([next_antenna | rest], boundary) do
    # Logger.debug("Inspecting all antennas related to #{inspect(next_antenna)}")
    [next_antenna | more_pairwise_antinodes(next_antenna, rest, boundary)] ++
      more_all_antinodes(rest, boundary)
  end

  @spec more_pairwise_antinodes(%Point{}, list(%Point{}), {integer(), integer()}) ::
          list(%Point{})
  defp more_pairwise_antinodes(_, [], _) do
    # Logger.debug("Have paired antenna against all possible combinations, time to quit.")
    []
  end

  defp more_pairwise_antinodes(start_antenna, [next_antenna | rest], boundary) do
    # Logger.debug("Pairing antennas #{inspect(start_antenna)} and #{inspect(next_antenna)}")
    slope = find_slope(start_antenna, next_antenna)
    antinodes = find_all_antinodes(start_antenna, slope, boundary)

    antinodes ++ more_pairwise_antinodes(start_antenna, rest, boundary)
  end
end
