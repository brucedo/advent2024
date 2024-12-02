defmodule DayOne do

  def day_one() do 
    lines = Common.open(File.cwd, "day1.txt") |> Common.read_file_pipe() |> Common.close()
    pair_list = for string_pair <- lines do
      parse_string_pair(string_pair)
    end

    {left_ids, right_ids} = break_pairs(pair_list)
    sorted_left_ids = Enum.sort(left_ids)
    sorted_right_ids = Enum.sort(right_ids)

    distances = find_distance(sorted_left_ids, sorted_right_ids)

    total_distance = Enum.sum(distances)

    IO.puts("The total distance is #{total_distance}" )

    dupe_map = count_duplicates(right_ids)

    similarities = Enum.map(left_ids, fn id -> id * Map.get(dupe_map, id, 0) end) |> Enum.sum()

    IO.puts("The total similarities are #{similarities}")

  end

  @spec parse_string_pair(String.t()) :: {integer(), integer()}
  def parse_string_pair(input_string) do 
    String.trim(input_string) |> String.split() |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

  @spec break_pairs([{integer(), integer()}]) :: {[integer()], [integer()]} 
  def break_pairs([]) do 
    {[], []}
  end

  def break_pairs([{left, right} | tail]) do 
    {left_list, right_list} = break_pairs(tail)

    {[left | left_list], [right | right_list]}
  end

  @spec find_distance([integer()], [integer()]) :: [integer()]
  def find_distance([], []) do 
    []
  end

  def find_distance([left_head | left_list], [right_head | right_list]) do 
    [abs(left_head - right_head) | find_distance(left_list, right_list)]
  end

  @spec count_duplicates(list(integer())) :: %{integer() => integer()}
  def count_duplicates(list_of_dupes) do 
    Enum.reduce(list_of_dupes, %{}, fn element, acc -> 
      Map.get_and_update(acc, element, fn curr -> {curr, if curr do curr + 1 else 1 end }  end) |> elem(1)
    end)
  end

end
