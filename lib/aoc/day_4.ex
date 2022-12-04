defmodule AOC.Day4 do
  defp collect(),
    do:
      AOC.Utils.load_day(4)
      |> Enum.map(fn l -> l |> String.split(",") end)
      |> Enum.map(fn [f, s] ->
        [
          f |> String.split("-") |> Enum.map(&String.to_integer/1),
          s |> String.split("-") |> Enum.map(&String.to_integer/1)
        ]
      end)

  defp collect(true),
    do:
      [
        "2-4,6-8",
        "2-3,4-5",
        "5-7,7-9",
        "2-8,3-7",
        "6-6,4-6",
        "2-6,4-8"
      ]
      |> Enum.map(fn l -> l |> String.split(",") end)
      |> Enum.map(fn [f, s] ->
        [
          f |> String.split("-") |> Enum.map(&String.to_integer/1),
          s |> String.split("-") |> Enum.map(&String.to_integer/1)
        ]
      end)

  defp contains([[fStart, fEnd], [sStart, sEnd]]) when fStart <= sStart and fEnd >= sEnd, do: true
  defp contains([[fStart, fEnd], [sStart, sEnd]]) when sStart <= fStart and sEnd >= fEnd, do: true
  defp contains(_), do: false

  defp overlaps([[fStart, fEnd], [sStart, _]]) when fStart <= sStart and fEnd >= sStart, do: true
  defp overlaps([[fStart, _], [sStart, sEnd]]) when sStart <= fStart and sEnd >= fStart, do: true
  defp overlaps(_), do: false

  def solve_one() do
    collect()
    |> Enum.filter(&contains/1)
    |> Enum.count()
  end

  def solve_two() do
    collect()
    |> Enum.filter(&overlaps/1)
    |> Enum.count()
  end
end
