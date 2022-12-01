defmodule AOC.Utils do
  def load_day(day, split),
    do:
      Path.join(:code.priv_dir(:aoc22), "day_#{day}.txt")
      |> File.read!()
      |> String.split(split)

  def load_day(day), do: load_day(day, "\n")
end
