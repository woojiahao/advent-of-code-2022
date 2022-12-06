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
  defp solve(_, _), do: raise("Invalid day and part")

  defp prompt() do
    day =
      IO.gets("What day do you want to solve?\t\t")
      |> String.trim()
      |> String.to_integer()

    part =
      IO.gets("Which part do you want to solve?\t")
      |> String.trim()
      |> String.to_integer()

    solve(day, part) |> IO.inspect(charlists: :as_lists)
  end

  defp today() do
    diff = Date.diff(Date.utc_today(), ~D[2022-12-01]) + 1
    solve(diff, 1) |> IO.inspect(charlists: :as_lists)
    solve(diff, 2) |> IO.inspect(charlists: :as_lists)
  end

  def start(_type, _args) do
    default? = IO.gets("Run today's problems? :: ") |> String.replace("\n", "")

    case default? do
      "" -> today()
      _ -> prompt()
    end

    children = []
    Supervisor.start_link(children, strategy: :one_for_all, name: AOC.Supervisor)
  end
end
