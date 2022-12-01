defmodule AOC do
  use Application

  def solve(1, 1), do: AOC.Day1.solve_one()
  def solve(1, 2), do: AOC.Day1.solve_two()
  def solve(_, _), do: raise("Invalid day and part")

  def start(_type, _args) do
    day =
      IO.gets("What day do you want to solve?\t\t")
      |> String.replace("\n", "")
      |> String.to_integer()

    part =
      IO.gets("Which part do you want to solve?\t")
      |> String.replace("\n", "")
      |> String.to_integer()

    solve(day, part) |> IO.inspect(charlists: :as_lists)
    children = []
    Supervisor.start_link(children, strategy: :one_for_all, name: AOC.Supervisor)
  end
end
