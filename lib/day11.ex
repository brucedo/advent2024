defmodule Day11 do
  require Logger

  def run() do
    lines =
      Common.open(File.cwd(), "day11.txt")
      |> Common.read_file_pipe()
      |> Common.close()

    stones = List.first(lines) |> String.split() |> Enum.map(&String.to_integer/1)

    mutations =
      for stone <- stones do
        Logger.debug("Sequencing stone #{inspect(stone)}")
        run_sequence(stone, 75)
      end

    # |> List.flatten()

    # IO.puts("Mutations: #{inspect(mutations)}")
    IO.puts("Total stone count: #{inspect(Enum.sum(mutations))}")
  end

  @spec run_sequence(integer(), integer()) :: integer()
  def run_sequence(stone, 1) do
    length(mutate(stone))
    # 1
  end

  def run_sequence(stone, iterations_remaining) do
    # Logger.debug("stone for iteration #{iterations_remaining}: #{inspect(stone)}")
    products = mutate(stone)

    temp =
      Enum.map(products, &run_sequence(&1, iterations_remaining - 1))

    # Logger.debug("#{inspect(temp)}")

    temp2 = temp |> Enum.sum()

    # Logger.debug("#{inspect(temp2)}")

    temp2

    # |> List.flatten()
  end

  @spec mutate(integer()) :: [integer()]
  def mutate(0) do
    [1]
  end

  def mutate(number) do
    digit_count = Integer.to_string(number) |> String.length()

    case rem(digit_count, 2) do
      0 ->
        shifter = Integer.pow(10, Integer.floor_div(digit_count, 2))
        [Integer.floor_div(number, shifter), rem(number, shifter)]

      1 ->
        [number * 2024]
    end

    # [Integer.floor_div(even, shifter), rem(even, shifter)]
  end

  # def mutate(odd) do
  #   Logger.debug("Odd path picked for stone #{inspect(odd)}")
  # end
end
