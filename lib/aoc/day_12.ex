defmodule AOC.Day12 do
  defp collect() do
    data =
      AOC.Utils.load_day(12)
      |> Enum.map(&String.graphemes/1)

    start_index = {sr, sc} = find_ch(data, "S")
    end_index = {er, ec} = find_ch(data, "E")

    data =
      data
      |> List.replace_at(sr, data |> Enum.at(sr) |> List.replace_at(sc, "a"))
      |> List.replace_at(er, data |> Enum.at(er) |> List.replace_at(ec, "z"))

    {data, start_index, end_index}
  end

  defp find_ch(m, ch),
    do:
      m
      |> Enum.find_index(fn row -> Enum.any?(row, &(&1 == ch)) end)
      |> then(fn row -> {row, m |> Enum.at(row) |> Enum.find_index(&(&1 == ch))} end)

  defp at(m, r, c), do: m |> Enum.at(r) |> Enum.at(c)
  defp ord(s), do: :binary.first(s)
  defp gen_key({r, c}), do: "#{r},#{c}"

  defp get_neighbors(m, r, c) do
    [[1, 0], [0, 1], [-1, 0], [0, -1]]
    |> Enum.map(fn [dr, dc] -> {r + dr, c + dc} end)
    |> Enum.filter(fn {nr, nc} ->
      nr in 0..(length(m) - 1) and nc in 0..(length(Enum.at(m, 0)) - 1)
    end)
    |> Enum.filter(fn {nr, nc} ->
      el = at(m, nr, nc)
      o = if at(m, r, c) == "S", do: ord("a"), else: ord(at(m, r, c))

      if el == "E",
        do: true,
        else: ord(el) - o <= 1
    end)
  end

  defp bfs(_, [], _, paths), do: paths

  defp bfs(m, [{r, c} | rest], visited, paths) do
    neighbors = get_neighbors(m, r, c)

    to_visit = neighbors |> Enum.filter(fn n -> !(gen_key(n) in visited) end)

    updated_paths =
      to_visit
      |> Enum.reduce(paths, fn coord, acc ->
        acc |> Map.put_new(gen_key(coord), Map.get(acc, gen_key({r, c})) + 1)
      end)

    rest = (rest ++ to_visit) |> Enum.uniq()

    bfs(m, rest, [gen_key({r, c}) | visited], updated_paths)
  end

  defp solve(m, start, target),
    do: bfs(m, [start], [], %{gen_key(start) => 0}) |> Map.get(gen_key(target))

  def solve_one() do
    collect()
    |> then(fn {m, start, target} -> solve(m, start, target) end)
  end

  defp find_a(m, r, _, a) when r == length(m), do: a

  defp find_a(m, r, c, a) do
    updated_c = if c == length(m |> Enum.at(0)), do: 0, else: c + 1
    updated_r = if c == length(m |> Enum.at(0)), do: r + 1, else: r
    updated_a = if at(m, r, c) == "a", do: [{r, c} | a], else: a

    find_a(m, updated_r, updated_c, updated_a)
  end

  def solve_two() do
    collect()
    |> then(fn {m, _, target} ->
      find_a(m, 0, 0, []) |> Enum.map(&solve(m, &1, target)) |> Enum.min()
    end)
  end
end
