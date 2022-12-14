defmodule AOC.Day13 do
  defp collect(),
    do:
      AOC.Utils.load_day(13, "\n\n")
      |> Enum.map(&String.split(&1, "\n"))
      |> Enum.map(fn [l, r] ->
        {l |> Code.eval_string() |> elem(0), r |> Code.eval_string() |> elem(0)}
      end)

  defp compare([], [_ | _]), do: :valid
  defp compare([_ | _], []), do: :invalid
  defp compare([], []), do: :inconclusive

  defp compare([l | lr], [r | rr]) when is_integer(l) and is_integer(r) do
    cond do
      l == r -> compare(lr, rr)
      true -> if l < r, do: :valid, else: :invalid
    end
  end

  defp compare([l | lr], [r | rr]) when is_list(l) or is_list(r) do
    left = if is_list(l), do: l, else: [l]
    right = if is_list(r), do: r, else: [r]

    case status = compare(left, right) do
      :inconclusive -> compare(lr, rr)
      _ -> status
    end
  end

  defp full_flat(l) do
    has_inner_list? = l |> Enum.any?(fn el -> is_list(el) end)

    if has_inner_list? do
      l
      |> Enum.reduce([], fn
        el, acc when is_integer(el) -> acc ++ [el]
        [], acc -> acc ++ [0]
        el, acc when is_list(el) -> acc ++ el
      end)
      |> full_flat()
    else
      l
    end
  end

  def solve_one() do
    collect()
    |> Enum.with_index(1)
    |> Enum.filter(fn {{l, r}, _} -> compare(l, r) == :valid end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def solve_two() do
    collect()
    |> Enum.flat_map(fn {l, r} -> [l, r] end)
    |> then(fn l -> l ++ [[[2]], [[6]]] end)
    |> Enum.map(fn el -> {el, full_flat(el)} end)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.with_index(1)
    |> Enum.filter(fn
      {{[[2]], _}, _} -> true
      {{[[6]], _}, _} -> true
      {_, _} -> false
    end)
    |> then(fn [{_, f}, {_, s}] -> f * s end)
  end
end
