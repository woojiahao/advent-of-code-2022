defmodule AOC.Day6 do
  @data AOC.Utils.load_day(6) |> Enum.at(0) |> String.graphemes()

  defp calculate_offset(window),
    do:
      window
      |> Enum.zip(0..length(window))
      |> Enum.group_by(&elem(&1, 0))
      |> Enum.map(fn {_, value} -> value |> Enum.map(&elem(&1, 1)) end)
      |> Enum.filter(&(&1 |> length() > 1))
      |> Enum.map(fn l -> l |> Enum.at(length(l) - 2) end)
      |> Enum.max(fn -> nil end)

  defp parse(chars, s, e) do
    offset = chars |> Enum.slice(s..e) |> calculate_offset()

    case offset do
      nil -> e + 1
      _ -> parse(chars, s + offset + 1, e + offset + 1)
    end
  end

  def solve_one(), do: @data |> parse(0, 3)

  def solve_two(), do: @data |> parse(0, 13)
end
