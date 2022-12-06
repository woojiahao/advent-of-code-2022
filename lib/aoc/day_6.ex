defmodule AOC.Day6 do
  defp collect(),
    do:
      AOC.Utils.load_day(6)
      |> Enum.at(0)
      |> String.graphemes()

  defp calculate_offset([a, a, _, _]), do: 1
  defp calculate_offset([a, _, a, _]), do: 1
  defp calculate_offset([a, _, _, a]), do: 1
  defp calculate_offset([_, b, b, _]), do: 2
  defp calculate_offset([_, b, _, b]), do: 2
  defp calculate_offset([_, _, c, c]), do: 3

  defp parse(chars), do: parse(chars, 0, 3)

  # [s, e]
  defp parse(chars, s, e) do
    window = chars |> Enum.slice(s..e)

    unique_size = window |> MapSet.new() |> MapSet.size()

    cond do
      unique_size == length(window) ->
        offset = calculate_offset(window)
        parse(chars, s + offset, e + offset)

      true ->
        e + 1
    end
  end

  defp parse_long(chars), do: parse_long(chars, 0, 13)

  defp calculate_offset_long(window) do
    window
    |> Enum.zip(0..length(window))
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.map(fn {_, value} -> value |> Enum.map(&elem(&1, 1)) end)
    |> Enum.filter(&(&1 |> length() > 1))
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(fn [_ | [target | _]] -> target end)
    |> Enum.max(fn -> nil end)
  end

  defp parse_long(chars, s, e) do
    window = chars |> Enum.slice(s..e)

    duplicate_index = window |> calculate_offset_long()

    case duplicate_index do
      nil -> e + 1
      _ -> parse_long(chars, s + duplicate_index + 1, e + duplicate_index + 1)
    end
  end

  def solve_one() do
    collect()
    # |> parse()
    |> parse_long(0, 3)
  end

  def solve_two() do
    collect() |> parse_long()
  end
end
