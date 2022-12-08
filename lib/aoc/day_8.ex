defmodule AOC.Day8 do
  defp collect(),
    do:
      AOC.Utils.load_day(8)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(fn l -> l |> Enum.map(&String.to_integer/1) end)

  # Assuming square grid
  defp count_edges(g), do: (g |> Enum.at(0) |> length()) * 4 - 4

  defp up(g, r, c), do: g |> Enum.slice(0..(r - 2)) |> Enum.map(&Enum.at(&1, c - 1))
  defp down(g, r, c), do: g |> Enum.slice(r..(length(g) - 1)) |> Enum.map(&Enum.at(&1, c - 1))
  defp left(g, r, c), do: g |> Enum.at(r - 1) |> Enum.slice(0..(c - 2))
  defp right(g, r, c), do: g |> Enum.at(r - 1) |> Enum.slice(c..(length(g) - 1))
  defp cur(g, r, c), do: g |> Enum.at(r - 1) |> Enum.at(c - 1)

  defp all(g, r, c),
    do: [
      up(g, r, c) |> Enum.reverse(),
      down(g, r, c),
      left(g, r, c) |> Enum.reverse(),
      right(g, r, c)
    ]

  defp visible?(g, r, c),
    do:
      if(all(g, r, c) |> Enum.any?(fn d -> d |> Enum.all?(&(&1 < cur(g, r, c))) end),
        do: 1,
        else: 0
      )

  defp search(g), do: search(g, 2, 2, count_edges(g))
  defp search(g, r, _, v) when r == length(g), do: v
  defp search(g, r, c, v) when c == length(g) - 1, do: search(g, r + 1, 2, v + visible?(g, r, c))
  defp search(g, r, c, v), do: search(g, r, c + 1, v + visible?(g, r, c))

  defp score(row, cur) do
    visible = row |> Enum.take_while(&(&1 < cur))
    if length(visible) == length(row), do: length(visible), else: length(visible) + 1
  end

  defp total(g, r, c),
    do: all(g, r, c) |> Enum.map(&score(&1, cur(g, r, c))) |> Enum.reduce(&(&1 * &2))

  defp scenic(g), do: scenic(g, 2, 2, 0)
  defp scenic(g, r, _, s) when r == length(g), do: s
  defp scenic(g, r, c, s) when c == length(g) - 1, do: scenic(g, r + 1, 2, max(total(g, r, c), s))
  defp scenic(g, r, c, s), do: scenic(g, r, c + 1, max(total(g, r, c), s))

  def solve_one(), do: collect() |> search()

  def solve_two(), do: collect() |> scenic()
end
