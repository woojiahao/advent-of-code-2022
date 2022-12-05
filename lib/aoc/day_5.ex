defmodule AOC.Day5 do
  defp collect() do
    [crate_lines, instruction_lines] = AOC.Utils.load_day(5, "\n\n")
    crate_row_regex = ~r/\[(\w)\]/
    instruction_row_regex = ~r/move (\d*) from (\d*) to (\d*)/

    tower =
      crate_lines
      |> String.split("\n")
      |> Enum.slice(0..7)
      |> Enum.map(fn row ->
        crate_row_regex
        |> Regex.split(row, include_captures: true, trim: true)
        |> Enum.filter(&(&1 |> String.length() > 1))
      end)
      |> Enum.map(&parse_crate_row/1)
      |> generate_crate_tower()

    instructions =
      instruction_lines
      |> String.split("\n")
      |> Enum.map(fn row ->
        instruction_row_regex
        |> Regex.run(row)
        |> Enum.slice(1..3)
        |> Enum.map(&String.to_integer/1)
      end)

    {tower, instructions}
  end

  defp parse_crate_row(row), do: parse_crate_row(row, %{}, 1)

  defp parse_crate_row([], indices, _), do: indices

  defp parse_crate_row([cur | rest], indices, index) do
    if cur |> String.trim() |> String.length() > 0 do
      parse_crate_row(rest, Map.put(indices, index, cur), index + 1)
    else
      skipped = div((cur |> String.length()) - 1, 4)
      parse_crate_row(rest, indices, index + skipped)
    end
  end

  defp generate_crate_tower(rows), do: generate_crate_tower(rows |> Enum.reverse(), %{})

  defp generate_crate_tower([], tower), do: tower

  defp generate_crate_tower([row | rest], tower) do
    new_tower =
      row
      |> Enum.reduce(tower, fn {col, crate}, acc ->
        if tower |> Map.has_key?(col) do
          acc |> Map.get_and_update!(col, fn cur -> {cur, [crate | cur]} end) |> elem(1)
        else
          acc |> Map.put(col, [crate])
        end
      end)

    generate_crate_tower(rest, new_tower)
  end

  defp move_crates([], tower), do: tower

  defp move_crates([[quantity, from, to] | rest], tower) do
    updated_tower =
      1..quantity
      |> Enum.reduce(tower, fn _, acc ->
        {original, updated} =
          acc
          |> Map.get_and_update!(
            from,
            fn
              [] -> {[], []}
              [top | remaining] -> {[top | remaining], remaining}
            end
          )

        to_remove = original |> Enum.at(0)

        if to_remove != nil do
          updated
          |> Map.get_and_update!(to, fn cur -> {cur, [to_remove | cur]} end)
          |> elem(1)
        else
          updated
        end
      end)

    move_crates(rest, updated_tower)
  end

  defp bulk_move_crates([], tower), do: tower

  defp bulk_move_crates([[quantity, from, to] | rest], tower) do
    {original, updated} =
      tower
      |> Map.get_and_update!(from, fn cur -> {cur, cur |> Enum.slice(quantity..length(cur))} end)

    to_move = original |> Enum.slice(0..(quantity - 1))

    updated_tower =
      updated |> Map.get_and_update!(to, fn cur -> {cur, to_move ++ cur} end) |> elem(1)

    bulk_move_crates(rest, updated_tower)
  end

  defp get_top_crates(tower),
    do: tower |> Enum.map(&(&1 |> elem(1) |> Enum.at(0) |> String.at(1))) |> Enum.join("")

  def solve_one() do
    {tower, instructions} = collect()

    move_crates(instructions, tower) |> get_top_crates()
  end

  def solve_two() do
    {tower, instructions} = collect()

    bulk_move_crates(instructions, tower) |> get_top_crates()
  end
end
