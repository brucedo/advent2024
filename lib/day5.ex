defmodule Day5 do
  require Logger

  def run() do
    lines =
      Common.open(File.cwd(), "day5.txt")
      |> Common.read_file_pipe()
      |> Common.close()

    [rules | [pages | []]] =
      Enum.chunk_while(
        lines,
        [],
        fn line, acc ->
          if String.trim(line) == "" do
            {:cont, acc, []}
          else
            {:cont, [line | acc]}
          end
        end,
        fn acc -> {:cont, acc, []} end
      )

    ruleset =
      Enum.map(rules, &make_rule/1)
      |> Enum.reduce(MapSet.new(), fn rule, acc -> MapSet.put(acc, rule) end)

    page_releases =
      Enum.map(pages, fn page_set -> String.split(page_set, ",") end)
      |> Enum.map(fn one_releases_pages ->
        for page <- one_releases_pages do
          String.to_integer(page)
        end
      end)

    # compliant_releases =
    #   filter_releases_by_compliance(page_releases, ruleset, true)
    #   |> Enum.map(fn index -> Enum.at(page_releases, index) end)
    #
    # middle_numbers =
    #   Enum.map(compliant_releases, fn release -> Enum.at(release, floor(length(release) / 2)) end)
    #
    # sum = Enum.sum(middle_numbers)
    #
    # IO.puts("The sum of all the middle numbers of all the compliant releases is #{sum}")
    #
    unordered_releases =
      filter_releases_by_compliance(page_releases, ruleset, false)
      |> Enum.map(fn index -> Enum.at(page_releases, index) end)

    #
    # ordered_releases =
    #   Enum.map(unordered_releases, fn release ->
    #     {release, produce_ordered_ruleset_for(release, ruleset)}
    #   end)
    #   |> Enum.map(fn {pages, rules} -> order_pages_with_rules(pages, rules) end)
    #
    # # Well something stupid is going on, let's find out what.
    # double_checked_releases =
    #   filter_releases_by_compliance(ordered_releases, ruleset, true)
    #   |> Enum.map(fn index -> Enum.at(ordered_releases, index) end)
    #
    ordered_pages =
      Enum.map(unordered_releases, fn page ->
        Enum.reduce(page, [], fn page, ordered_set ->
          load_page(page, ordered_set, ruleset)
        end)
      end)

    Logger.debug("#{inspect(ordered_pages)}")

    middle_numbers =
      Enum.map(ordered_pages, fn release -> Enum.at(release, floor(length(release) / 2)) end)

    sum = Enum.sum(middle_numbers)

    IO.puts("The sum of all the middle numbers of all the reordered releases is #{sum}")
  end

  @spec load_page(integer(), list(integer()), MapSet.t()) :: list(integer())
  def load_page(current_page, [], _) do
    [current_page]
  end

  def load_page(new_page, [current_page | rest_of_manual], page_rules) do
    cond do
      MapSet.member?(page_rules, {new_page, current_page}) ->
        [new_page | [current_page | rest_of_manual]]

      MapSet.member?(page_rules, {current_page, new_page}) ->
        [current_page | load_page(new_page, rest_of_manual, page_rules)]
    end
  end

  @spec produce_ordered_ruleset_for(list(integer()), MapSet.t()) :: %{integer() => integer()}
  def produce_ordered_ruleset_for(pages, full_ruleset) do
    catalogue = MapSet.new(pages)
    Logger.debug("Set of pages in release: #{inspect(catalogue)}")

    # Enum.filter(full_ruleset, fn {left, right} ->
    #   MapSet.member?(catalogue, left) && MapSet.member?(catalogue, right)
    # end)
    # |> Enum.reduce([], fn elem, acc -> ordered_insert(acc, elem) end)
    # |> Enum.with_index()
    # |> Map.new()
    temp_filtered =
      Enum.filter(full_ruleset, fn {left, right} ->
        MapSet.member?(catalogue, left) && MapSet.member?(catalogue, right)
      end)

    Logger.debug(
      "Filtered set of rules that applies to this set of pages: #{inspect(temp_filtered, limit: :infinity)}"
    )

    temp_ordered =
      Enum.reduce(temp_filtered, [], fn elem, acc ->
        temp = ordered_insert(acc, elem)
        Logger.debug("Final insert for #{inspect(elem)}: #{inspect(temp)}")
        temp
      end)

    IO.puts("Ordered set of rules: #{inspect(temp_ordered)}")

    Enum.with_index(temp_ordered) |> Map.new()
  end

  @spec order_pages_with_rules(list(integer()), %{integer() => integer()}) :: list(integer())
  def order_pages_with_rules(pages, ordered_rules) do
    Enum.sort(pages, fn page1, page2 ->
      Map.get(ordered_rules, page1) < Map.get(ordered_rules, page2)
    end)
  end

  @spec filter_releases_by_compliance(list(list(integer())), MapSet.t(), boolean()) ::
          list(integer())
  defp filter_releases_by_compliance(releases, ruleset, ordered?) do
    Enum.map(releases, &expand_pages/1)
    |> Enum.map(&flip/1)
    |> Enum.map(fn violations ->
      Enum.reduce(violations, true, fn violable, acc ->
        acc && !MapSet.member?(ruleset, violable)
      end)
    end)
    |> Enum.with_index()
    |> Enum.filter(fn {no_violation, _} -> no_violation == ordered? end)
    |> Enum.map(fn {_, index} -> index end)
  end

  @spec ordered_insert(list(integer()), {integer(), integer()} | {integer()}) :: list(integer())
  def ordered_insert([], remainder) do
    Logger.debug(
      "The single or tuple #{inspect(remainder)} has no matches and is going at the end."
    )

    Tuple.to_list(remainder)
  end

  def ordered_insert([head | rest], {second}) when second == head do
    Logger.debug(
      "The single #{inspect(second)} matches #{inspect(head)} and so both values in this set are already inserted."
    )

    [head | rest]
  end

  def ordered_insert([head | rest], {first, second}) when first == head do
    Logger.debug(
      "The first element #{inspect(first)} matches #{inspect(head)} and so we will continue trying to insert #{inspect(second)}"
    )

    [head | ordered_insert(rest, {second})]
  end

  def ordered_insert([head | rest], {first, second}) when second == head do
    Logger.debug(
      "The second element #{inspect(second)} matches #{inspect(head)} but first has not yet been matched"
    )

    Logger.debug(
      "Therefore either first exists further down and must be popped or else it does not yet exist"
    )

    Logger.debug("Either way, first should be injected before second.")
    shuffled_list = shuffle(rest, first)
    [first | [head | shuffled_list]]
  end

  def ordered_insert([head | rest], ordered) do
    Logger.debug(
      "Neither first nor second of #{inspect(ordered)} match any prior rule, so we try again."
    )

    [head | ordered_insert(rest, ordered)]
  end

  defp shuffle([], _) do
    []
  end

  defp shuffle([head | rest], quarry) when head == quarry do
    Logger.debug(
      "Shuffle has found the quarry #{inspect(quarry)} - removing it and returning only #{inspect(rest)}"
    )

    rest
  end

  defp shuffle([head | rest], quarry) do
    [head | shuffle(rest, quarry)]
  end

  @spec make_rule(String.t()) :: {integer(), integer()}
  def make_rule(rule_string) do
    rule_list =
      String.split(rule_string, "|")
      |> Enum.map(fn numeral -> String.to_integer(numeral) end)

    List.to_tuple(rule_list)
  end

  @spec expand_pages(list(integer())) :: list({integer(), integer()})
  def expand_pages([second_last | [last | []]]) do
    [{second_last, last}]
  end

  def expand_pages([current | rest]) do
    combos =
      for next_page <- rest do
        {current, next_page}
      end

    combos ++ expand_pages(rest)
  end

  @spec flip(list({integer(), integer()})) :: list({integer(), integer()})
  def flip(real_ordering) do
    Enum.map(real_ordering, fn {left, right} -> {right, left} end)
  end
end
