defmodule Day7 do
  def run() do
    lines =
      Common.open(File.cwd(), "day7.txt") |> Common.read_file_pipe() |> Common.close()

    calibrations = Enum.filter(lines, &(&1 != "")) |> Enum.map(&decompose_calibration/1)

    total_of_valid_calibrations =
      Enum.map(calibrations, fn {total, measurements} -> {total, permute_list(measurements)} end)
      |> Enum.filter(fn {total, combinations} ->
        Enum.find(combinations, fn combination -> combination == total end) != nil
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sum()

    IO.puts("Total of the valid calibrations is #{inspect(total_of_valid_calibrations)}")

    valid_with_catenation =
      Enum.map(calibrations, fn {total, measurements} ->
        {total, permute_list_with_catenate(measurements)}
      end)
      |> Enum.filter(fn {total, combinations} -> Enum.find(combinations, &(&1 == total)) end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sum()

    IO.puts(
      "Total of the valid calibrations including catenation is #{inspect(valid_with_catenation)}"
    )
  end

  @spec decompose_calibration(String.t()) :: {integer(), list(integer())}
  def decompose_calibration(line) do
    [total | measurements] = String.split(line, ":")

    measurement_numbers =
      Enum.map(measurements, &String.split/1)
      |> Enum.flat_map(& &1)
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)

    {String.trim(total) |> String.to_integer(), measurement_numbers}
  end

  @spec permute_list(list(integer())) :: list(integer())
  def permute_list([left | [right | []]]) do
    {sum, product} = permute_operations(left, right)

    [sum, product]
  end

  def permute_list([left | [right | remainder]]) do
    {sum, product} = permute_operations(left, right)

    permute_list([sum | remainder]) ++ permute_list([product | remainder])
  end

  @spec permute_operations(integer(), integer()) :: {integer(), integer()}
  def permute_operations(left, right) do
    {left + right, left * right}
  end

  @spec permute_with_catenate(integer(), integer()) :: {integer(), integer(), integer()}
  def permute_with_catenate(left, right) do
    {left + right, left * right,
     String.to_integer(Integer.to_string(left) <> Integer.to_string(right))}
  end

  @spec permute_list_with_catenate(list(integer())) :: list(integer())
  def permute_list_with_catenate([left | [right | []]]) do
    {sum, product, catenation} = permute_with_catenate(left, right)

    [sum, product, catenation]
  end

  def permute_list_with_catenate([left | [right | remainder]]) do
    {sum, product, catenation} = permute_with_catenate(left, right)

    permute_list_with_catenate([sum | remainder]) ++
      permute_list_with_catenate([product | remainder]) ++
      permute_list_with_catenate([catenation | remainder])
  end
end
