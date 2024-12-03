defmodule Day3 do
  def run do
    lines =
      Common.open(File.cwd(), "day3.txt") |> Common.read_file_pipe() |> Common.close()

    total =
      Enum.map(lines, &match_muls/1)
      |> Enum.flat_map(fn muls_in_line -> muls_in_line end)
      |> Enum.map(&decode_str/1)
      |> Enum.map(fn {left, right} -> left * right end)
      |> Enum.sum()

    IO.puts("The total should be #{total}")

    strings_with_conditionals =
      Enum.map(lines, &match_muls_and_cond/1)
      |> Enum.flat_map(fn muls_and_conds -> muls_and_conds end)

    only_included_muls = eval(strings_with_conditionals, :proceed)

    conditional_total =
      Enum.map(only_included_muls, &decode_str/1)
      |> Enum.map(fn {left, right} -> left * right end)
      |> Enum.sum()

    IO.puts("The conditinal total should be #{conditional_total}")
  end

  @spec eval(list(String.t()), atom()) :: list(String.t())
  def eval([], _) do
    []
  end

  def eval([current | rest], action) do
    case current do
      "do()" ->
        eval(rest, :proceed)

      "don't()" ->
        eval(rest, :pause)

      anything_else ->
        if action == :pause do
          eval(rest, action)
        else
          [anything_else | eval(rest, action)]
        end
    end
  end

  @spec match_muls_and_cond(String.t()) :: list(String.t())
  def match_muls_and_cond(statements) do
    matcher = ~r/mul\([0-9]+,[0-9]+\)|don't\(\)|do\(\)/

    case Regex.scan(matcher, statements) do
      nil -> []
      anything -> Enum.flat_map(anything, fn single -> single end)
    end
  end

  @spec match_muls(String.t()) :: list(String.t())
  def match_muls(statements) do
    mul_matcher = ~r/mul\([0-9]+,[0-9]+\)/

    case Regex.scan(mul_matcher, statements) do
      nil -> []
      anything -> Enum.flat_map(anything, fn single -> single end)
    end
  end

  @spec decode_str(String.t()) :: {integer(), integer()}
  def decode_str(mul_str) do
    numbers =
      String.replace_prefix(mul_str, "mul(", "")
      |> String.replace_suffix(")", "")
      |> String.split(",")
      |> Enum.map(fn number -> String.to_integer(number) end)

    List.to_tuple(numbers)
  end
end
