defmodule AOC.Day14 do
  @sand_source [500, 0]

  defp collect(),
    do:
      AOC.Utils.load_day(14)
      |> Enum.map(&String.split(&1, " -> "))
      |> Enum.map(fn l ->
        l |> Enum.map(fn c -> c |> String.split(",") |> Enum.map(&String.to_integer/1) end)
      end)
      |> then(fn rocks ->
        flattened = rocks |> Enum.flat_map(& &1)
        min_x = flattened |> Enum.min_by(fn [x, _] -> x end) |> Enum.at(0)
        max_x = flattened |> Enum.max_by(fn [x, _] -> x end) |> Enum.at(0)
        min_y = flattened |> Enum.min_by(fn [_, y] -> y end) |> Enum.at(1)
        max_y = flattened |> Enum.max_by(fn [_, y] -> y end) |> Enum.at(1)

        organized_rocks =
          rocks
          |> Enum.map(fn set ->
            set
            |> Enum.chunk_every(2, 1)
            |> then(fn chunks -> chunks |> Enum.slice(0..(length(chunks) - 2)) end)
          end)

        {organized_rocks, min_x, max_x, min_y, max_y}
      end)

  defp find_rocks(_, _, _, _, max_y, _, y, cave) when y > max_y, do: cave

  defp find_rocks(rocks, min_x, max_x, min_y, max_y, x, y, cave) do
    updated_x = if x == max_x, do: min_x, else: x + 1
    updated_y = if x == max_x, do: y + 1, else: y

    has_rock? =
      rocks
      |> Enum.any?(fn r ->
        r |> Enum.any?(fn [[fx, fy], [sx, sy]] -> x in fx..sx and y in fy..sy end)
      end)

    updated_cave = if has_rock?, do: [[x, y] | cave], else: cave

    find_rocks(rocks, min_x, max_x, min_y, max_y, updated_x, updated_y, updated_cave)
  end

  defp print_cave(rocks, min_x, max_x, min_y, max_y) do
    min_y..max_y
    |> Enum.reduce("", fn y, cave ->
      row =
        min_x..max_x
        |> Enum.reduce("", fn x, line ->
          if [x, y] in rocks, do: line <> "#", else: line <> "."
        end)

      cave <> row <> "\n"
    end)
    |> IO.puts()
  end

  def solve_one() do
    collect()
    |> then(fn {rocks, min_x, max_x, min_y, max_y} ->
      find_rocks(rocks, min_x, max_x, min_y, max_y, min_x, min_y, [])
    end)
    |> IO.puts()
  end

  def solve_two() do
  end
end
