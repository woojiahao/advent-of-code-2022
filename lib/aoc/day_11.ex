defmodule AOC.Day11 do
  defp collect(),
    do:
      AOC.Utils.load_day(11, "\n\n")
      |> Enum.map(&String.split(&1, "\n", trim: true))
      |> Enum.reduce([], fn [
                              _,
                              "  Starting items: " <> starting_items,
                              "  Operation: new = old " <> operation,
                              "  Test: divisible by " <> test,
                              "    If true: throw to monkey " <> true_monkey,
                              "    If false: throw to monkey " <> false_monkey
                            ],
                            acc ->
        items = starting_items |> String.split(", ") |> Enum.map(&String.to_integer/1)

        [operator, value] =
          operation
          |> String.split(" ")
          |> then(fn
            [operator, "old"] -> [operator, :old]
            [operator, value] -> [operator, String.to_integer(value)]
          end)

        [test_value, true_monkey_index, false_monkey_index] =
          [test, true_monkey, false_monkey] |> Enum.map(&String.to_integer/1)

        monkey = {items, [operator, value], test_value, true_monkey_index, false_monkey_index, 0}

        [monkey | acc]
      end)
      |> Enum.reverse()

  defp calc_worry(initial, "*", :old), do: initial * initial
  defp calc_worry(initial, "+", :old), do: initial + initial
  defp calc_worry(initial, "*", value), do: initial * value
  defp calc_worry(initial, "+", value), do: initial + value

  defp monkey_round(monkeys, is_worried), do: monkey_round(monkeys, 0, is_worried)
  defp monkey_round(monkeys, i, _) when i == length(monkeys), do: monkeys

  defp monkey_round(monkeys, index, is_worried) do
    {items, [operator, value], test, true_monkey, false_monkey, inspected} =
      monkeys |> Enum.at(index)

    highest_val = monkeys |> Enum.reduce(1, fn {_, _, t, _, _, _}, acc -> t * acc end)

    div_factor = if is_worried, do: 1, else: 3
    new_worry =
      items
      |> Enum.map(&calc_worry(&1, operator, value))
      |> Enum.map(&(div(&1, div_factor)))

    target_monkeys =
      new_worry |> Enum.map(&if rem(&1, test) == 0, do: true_monkey, else: false_monkey)

    updated_monkeys =
      target_monkeys
      |> Enum.zip(new_worry)
      |> Enum.reduce(monkeys, fn {target, new_worry}, acc ->
        {is, op, t, tm, fm, i} = acc |> Enum.at(target)
        shift = if is_worried, do: [rem(new_worry, highest_val)], else: [new_worry]
        new_items = is ++ shift

        acc
        |> List.replace_at(target, {new_items, op, t, tm, fm, i})
        |> List.replace_at(
          index,
          {[], [operator, value], test, true_monkey, false_monkey, inspected + length(items)}
        )
      end)

    monkey_round(updated_monkeys, index + 1, is_worried)
  end

  def solve_one() do
    monkeys = collect() |> IO.inspect(charlists: :as_lists)

    [f, s] =
      1..20
      |> Enum.reduce(monkeys, fn _, acc -> acc |> monkey_round(false) end)
      |> Enum.map(&elem(&1, 5))
      |> Enum.sort(:desc)
      |> Enum.take(2)

    f * s
  end

  def solve_two() do
    monkeys = collect()

    [f, s] =
      1..10000
      |> Enum.reduce(monkeys, fn
        i, acc when rem(i, 100) == 0 ->
          monkey_round(acc, true)

        _, acc ->
          monkey_round(acc, true)
      end)
      |> Enum.map(&elem(&1, 5))
      |> Enum.sort(:desc)
      |> Enum.take(2)

    f * s
  end
end
