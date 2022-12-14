defmodule AOC.Day13 do
  @moduledoc """
  Rules:
  1. If both are numbers
    a) left < right => whole input right order
    b) left > right => whole input wrong order
    c) left == right => move to next pair
  2. If both are lists, compare individual elements of list with rule (1)
    a) len(left) < len(right) => whole input right order
    b) len(left) > len(right) => whole input wrong order
    c) len(left) == len(right) => move to the next pair
  3. If one is an integer, convert to a list and compare only using (1) (rules of (2) do not apply)

  Status codes:
  1. 1 => valid
  2. 0 => inconclusive
  3. -1 => invalid
  """

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
      l < r -> :valid
      l == r -> compare(lr, rr)
      true -> :invalid
    end
  end

  defp compare([l | lr], [r | rr]) when is_list(l) or is_list(r) do
    left = if is_list(l), do: l, else: [l]
    right = if is_list(r), do: r, else: [r]

    case compare(left, right) do
      :valid -> :valid
      :inconclusive -> compare(lr, rr)
      _ -> :invalid
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
    [{_, f}, {_, s}] =
      collect()
      |> Enum.flat_map(fn {l, r} -> [l, r] end)
      |> then(fn l -> l ++ [[[2]], [[6]]] end)
      |> Enum.map(fn el -> {el, full_flat(el)} end)
      |> Enum.sort_by(&elem(&1, 1))
      |> IO.inspect(charlists: :as_list)
      |> Enum.with_index(1)
      |> Enum.filter(fn
        {{[[2]], _}, _} -> true
        {{[[6]], _}, _} -> true
        {_, _} -> false
      end)
      |> IO.inspect()

    f * s
  end
end
