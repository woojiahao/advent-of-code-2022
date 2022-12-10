defmodule AOC.Day10 do
  defp collect() do
    AOC.Utils.load_day(10)
    |> run()
    |> Enum.reverse()
  end

  # Returns what the list will look like during the cycle at the index (one-based)
  defp run(instructions), do: run(instructions, 0, [1])
  defp run([], _, values), do: values
  defp run(["noop" | rest], cycle, [x | _] = values), do: run(rest, cycle + 1, [x | values])

  defp run(["addx " <> value | rest], cycle, [x | _] = values),
    do: run(rest, cycle + 2, [x + String.to_integer(value) | [x | values]])

  defp map_pixel(during),
    do: map_pixel(during, 1, 0, %{1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => []})

  defp map_pixel([], _, _, drawing), do: drawing

  defp map_pixel([{_, x_start} | rest], r, c, drawing) do
    window = x_start..(x_start + 2)

    updated_c = if c + 1 == 40, do: 0, else: c + 1
    updated_r = if c + 1 == 40, do: r + 1, else: r

    if (c + 1) in window,
      do: map_pixel(rest, updated_r, updated_c, %{drawing | r => [c | drawing[r]]}),
      else: map_pixel(rest, updated_r, updated_c, drawing)
  end

  defp draw(drawing), do: draw(drawing, 1, [])
  defp draw(_, 7, final), do: final |> Enum.reverse()

  defp draw(drawing, r, final) do
    row_drawing = 0..39 |> Enum.map(fn i -> if i in drawing[r], do: "#", else: "." end)

    draw(drawing, r + 1, [row_drawing | final])
  end

  def solve_one() do
    1..length(collect())
    |> Enum.zip(collect())
    |> Enum.reduce(0, fn
      {20, v}, _ -> 20 * v
      {i, v}, acc when rem(i - 20, 40) == 0 -> acc + i * v
      _, acc -> acc
    end)
  end

  def solve_two() do
    1..length(collect())
    |> Enum.zip(collect())
    |> map_pixel()
    |> draw()
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()
  end
end
