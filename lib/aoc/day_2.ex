defmodule AOC.Day2 do
  defp collect(),
    do:
      AOC.Utils.load_day(2)
      |> Enum.map(fn r -> r |> String.split(" ") end)

  # A/X - Rock; B/Y - Paper; C/Z - Scissors
  defp score("B", "X"), do: 1
  defp score("C", "Y"), do: 2
  defp score("A", "Z"), do: 3

  defp score("A", "X"), do: 4
  defp score("B", "Y"), do: 5
  defp score("C", "Z"), do: 6

  defp score("C", "X"), do: 7
  defp score("A", "Y"), do: 8
  defp score("B", "Z"), do: 9

  defp decision("X", "A"), do: score("A", "Z")
  defp decision("X", "B"), do: score("B", "X")
  defp decision("X", "C"), do: score("C", "Y")

  defp decision("Y", "A"), do: score("A", "X")
  defp decision("Y", "B"), do: score("B", "Y")
  defp decision("Y", "C"), do: score("C", "Z")

  defp decision("Z", "A"), do: score("A", "Y")
  defp decision("Z", "B"), do: score("B", "Z")
  defp decision("Z", "C"), do: score("C", "X")

  def solve_one() do
    collect()
    |> Enum.map(fn [opp, me] -> score(opp, me) end)
    |> Enum.sum()
  end

  def solve_two() do
    collect()
    |> Enum.map(fn [opp, me] -> decision(me, opp) end)
    |> Enum.sum()
  end
end
