defmodule AOC.Day1 do
  defp collect() do
    AOC.Utils.load_day(1, "\n\n")
    |> Enum.map(fn l -> l |> String.split("\n") end)
    |> Enum.map(fn l -> l |> Enum.map(fn el -> el |> String.to_integer() end) end)
    |> Enum.map(fn l -> l |> Enum.sum() end)
  end

  def solve_one(), do: collect() |> Enum.max()

  def solve_two() do
    collect()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
