defmodule AOC.Day9 do
  defp collect(),
    do:
      AOC.Utils.load_day(9, "\n\n")
      |> Enum.at(0)
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [d, m] -> [d, String.to_integer(m)] end)

  # Treat v as a stack where the latest element is where the tail is currently
  # Pair of coordinates represents the head position
  defp connected?({hx, hy}, {tx, ty}), do: abs(hx - tx) <= 1 and abs(hy - ty) <= 1
  defp move_direction("R", {x, y}), do: {x + 1, y}
  defp move_direction("L", {x, y}), do: {x - 1, y}
  defp move_direction("U", {x, y}), do: {x, y + 1}
  defp move_direction("D", {x, y}), do: {x, y - 1}
  defp move?(moves), do: move?(moves, {0, 0}, [{0, 0}])
  defp move?([], _, tail), do: tail

  defp move?([[direction, dist] | rest], head, tail) do
    {next_head, next_tail} =
      1..dist
      |> Enum.reduce({head, tail}, fn
        _, {{hx, hy} = head, [{hx, hy} | _] = tail} ->
          {move_direction(direction, head), tail}

        _, {{hx, hy} = head, [{tx, ty} = cur_tail | _] = tail} ->
          next_head = {nhx, nhy} = move_direction(direction, head)

          if connected?(next_head, cur_tail),
            do: {next_head, tail},
            else:
              if(nhx == tx or nhy == ty,
                do: {next_head, [move_direction(direction, cur_tail) | tail]},
                else: {next_head, [{hx, hy} | tail]}
              )
      end)

    move?(rest, next_head, next_tail)
  end

  def solve_one() do
    collect()
    |> move?()
    |> Enum.reverse()
    |> Enum.uniq()
    |> Enum.count()
  end

  def solve_two() do
  end
end
