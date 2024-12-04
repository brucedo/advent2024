defmodule Point do
  defstruct x: -1, y: -1
end

defmodule Day4 do
  @spec indexer(String.t()) :: list({String.t(), integer()})
  def indexer(letter_sequence) do
    String.splitter(letter_sequence, "")
    |> Enum.filter(fn letter -> letter != "" end)
    |> Enum.with_index()
  end
end
