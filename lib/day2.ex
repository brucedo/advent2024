defmodule Day2 do
  require Logger

  def run() do
    lines = Common.open(File.cwd(), "day2.txt") |> Common.read_file_pipe() |> Common.close()

    reports =
      Enum.map(lines, &String.split/1)
      |> Enum.map(fn numbers ->
        for number <- numbers do
          String.to_integer(number)
        end
      end)

    safe_report_count = test_safety(reports)

    IO.puts("The number of safe reports: #{safe_report_count}")

    dampened_report_count = test_dampened_reports(reports)

    IO.puts("The number of reports that are safe with dampeneing: #{dampened_report_count}")
  end

  @spec test_dampened_reports(list(list(integer()))) :: integer()
  def test_dampened_reports(reports) do
    Enum.map(reports, fn report ->
      (monotonic?(report) && gradual?(report)) ||
        Enum.find(all_perms(report), fn subreport ->
          monotonic?(subreport) && gradual?(subreport)
        end) != nil
    end)
    |> Enum.filter(fn is_safe -> is_safe end)
    |> Enum.count()
  end

  @spec all_perms(list(integer())) :: list(list(integer()))
  def all_perms([_]) do
    []
  end

  def all_perms(to_sublist) do
    for index <- Range.new(0, length(to_sublist) - 1) do
      List.delete_at(to_sublist, index)
    end
  end

  @spec test_safety(list(list(integer()))) :: integer()
  def test_safety(reports) do
    Enum.map(reports, fn report -> monotonic?(report) && gradual?(report) end)
    |> Enum.filter(fn is_safe -> is_safe end)
    |> Enum.count()
  end

  @spec gradual?(list(integer())) :: boolean()
  def gradual?(to_test) do
    {_, paired_list} = pairify(to_test)

    out_of_bounds =
      Enum.map(paired_list, fn {left, right} -> abs(left - right) end)
      |> Enum.filter(fn difference -> difference == 0 || difference >= 4 end)

    length(out_of_bounds) == 0
  end

  @spec monotonic?(list(integer())) :: boolean()
  def monotonic?(to_test) do
    {_, paired_list} = pairify(to_test)

    differences = Enum.map(paired_list, fn {left, right} -> left - right end)

    {min, max} = Enum.min_max(differences)

    (min > 0 && max > 0) || (min < 0 && max < 0)
  end

  @spec pairify(list(integer())) :: {integer(), list({integer(), integer()})}

  defp pairify([last]) do
    {last, []}
  end

  defp pairify([current | tail]) do
    {next, paired_list} = pairify(tail)

    {current, [{current, next} | paired_list]}
  end
end
