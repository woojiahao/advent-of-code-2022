defmodule AOC.Day9 do
  defp collect(),
    do:
      AOC.Utils.load_day(9)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [d, m] -> [d, String.to_integer(m)] end)

  defp connected?({hx, hy}, {tx, ty}), do: abs(hx - tx) <= 1 and abs(hy - ty) <= 1

  defp move_head("R", {x, y}), do: {x + 1, y}
  defp move_head("L", {x, y}), do: {x - 1, y}
  defp move_head("U", {x, y}), do: {x, y + 1}
  defp move_head("D", {x, y}), do: {x, y - 1}

  defp catch_up({hx, hy} = head, {tx, ty} = tail) do
    if connected?(head, tail) do
      tail
    else
      sx = if hx == tx, do: 0, else: div(hx - tx, abs(hx - tx))
      sy = if hy == ty, do: 0, else: div(hy - ty, abs(hy - ty))
      {tx + sx, ty + sy}
    end
  end

  defp move(moves), do: move(moves, {0, 0}, [{0, 0}])
  defp move([], _, whole), do: whole
  defp move([[_, 0] | moves], next_head, whole), do: move(moves, next_head, whole)

  defp move([[dir, dist] | moves], head, [tail | _] = whole) do
    next_head = move_head(dir, head)
    next_tail = catch_up(next_head, tail)
    move([[dir, dist - 1] | moves], next_head, [next_tail | whole])
  end

  defp move_many(moves),
    do: move_many(moves, {0, 0}, 1..9 |> Enum.map(fn _ -> {0, 0} end), [{0, 0}])

  defp move_many([], _, _, whole), do: whole

  defp move_many([[_, 0] | moves], head, positions, whole),
    do: move_many(moves, head, positions, whole)

  defp move_many([[dir, dist] | moves], head, positions, whole) do
    next_head = move_head(dir, head)

    {_, [t | _] = next_positions} =
      positions
      |> Enum.reverse()
      |> Enum.reduce({next_head, []}, fn t, {h, l} ->
        next_t = catch_up(h, t)
        {next_t, [next_t | l]}
      end)

    move_many([[dir, dist - 1] | moves], next_head, next_positions, [t | whole])
  end

  def solve_one() do
    collect()
    |> move()
    |> Enum.uniq()
    |> Enum.reverse()
    |> Enum.count()
  end

  def solve_two() do
    collect()
    |> move_many()
    |> Enum.uniq()
    |> Enum.count()
  end
end
