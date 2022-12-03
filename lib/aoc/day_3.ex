defmodule AOC.Day3 do
  defp collect(true),
    do: [
      "vJrwpWtwJgWrhcsFMMfFFhFp",
      "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
      "PmmdzqPrVvPwwTWBwg",
      "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
      "ttgJtRGJQctTZtZT",
      "CrZsJsPPZsGzwwsLwLmpwMDw"
    ]

  defp collect(), do: AOC.Utils.load_day(3)

  defp convert_ascii(<<v::utf8>>) when v >= 65 and v <= 90, do: v - 38
  defp convert_ascii(<<v::utf8>>) when v >= 97 and v <= 122, do: v - 96

  def solve_one() do
    collect(true)
    |> Enum.map(fn l -> l |> String.split_at(div(String.length(l), 2)) end)
    |> Enum.map(fn {l, r} -> [String.graphemes(l), String.graphemes(r)] end)
    |> Enum.map(fn [l, r] -> [MapSet.new(l), MapSet.new(r)] end)
    |> Enum.map(fn [l, r] -> MapSet.intersection(l, r) |> MapSet.to_list() |> Enum.at(0) end)
    |> Enum.map(&convert_ascii/1)
    |> Enum.sum()
  end

  def solve_two() do
    collect()
    |> Enum.chunk_every(3)
    |> Enum.map(fn l -> l |> Enum.map(fn sl -> MapSet.new(String.graphemes(sl)) end) end)
    |> Enum.map(fn [l, m, r] ->
      MapSet.intersection(l, m) |> MapSet.intersection(r) |> MapSet.to_list() |> Enum.at(0)
    end)
    |> Enum.map(&convert_ascii/1)
    |> Enum.sum()
  end
end
