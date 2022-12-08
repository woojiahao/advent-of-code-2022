defmodule AOC do
  use Application

  defp solve(1, 1), do: AOC.Day1.solve_one()
  defp solve(1, 2), do: AOC.Day1.solve_two()
  defp solve(2, 1), do: AOC.Day2.solve_one()
  defp solve(2, 2), do: AOC.Day2.solve_two()
  defp solve(3, 1), do: AOC.Day3.solve_one()
  defp solve(3, 2), do: AOC.Day3.solve_two()
  defp solve(4, 1), do: AOC.Day4.solve_one()
  defp solve(4, 2), do: AOC.Day4.solve_two()
  defp solve(5, 1), do: AOC.Day5.solve_one()
  defp solve(5, 2), do: AOC.Day5.solve_two()
  defp solve(6, 1), do: AOC.Day6.solve_one()
  defp solve(6, 2), do: AOC.Day6.solve_two()
  defp solve(7, 1), do: AOC.Day7.solve_one()
  defp solve(7, 2), do: AOC.Day7.solve_two()
  defp solve(8, 1), do: AOC.Day8.solve_one()
  defp solve(8, 2), do: AOC.Day8.solve_two()
  defp solve(_, _), do: raise("Invalid day and part")

  defp ask(prompt),
    do:
      IO.gets("#{prompt} :: ")
      |> String.replace("\n", "")

  defp prompt() do
    day =
      ask("What day do you want to solve?")
      |> String.to_integer()

    part =
      ask("Which part do you want to solve?")
      |> String.to_integer()

    solve(day, part) |> IO.inspect(charlists: :as_lists)
  end

  defp today() do
    diff = Date.diff(Date.utc_today(), ~D[2022-12-01]) + 1
    solve(diff, 1) |> IO.inspect(charlists: :as_lists)
    solve(diff, 2) |> IO.inspect(charlists: :as_lists)
  end

  def start(_type, _args) do
    case ask("Run today's problems? (blank to default to [yes])") do
      "" -> today()
      _ -> prompt()
    end

    children = []
    Supervisor.start_link(children, strategy: :one_for_all, name: AOC.Supervisor)
  end
end
