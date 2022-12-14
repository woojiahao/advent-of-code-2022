defmodule AOC.Day14 do
  @sand_source [500, 0]

  @moduledoc """
  Every sand dropped, we get the floor of the latest element directly below the sand source

  The initial target is one block directly above the floor. Once dropped, check if the floor
  has a left particle. If a left particle does not exist, then move the current particle to
  that position and check again. If the left particle exists, then check if the floor has a
  right particle. If a right particle does not exist, then move the current particle to that
  position and check again. IF the right particle exists, keep the particle at the original.

  As you check for positions, if the immediate left or right particles are filled, then don't
  move anymore
  """

  defp collect(),
    do:
      AOC.Utils.load_day(14)
      |> Enum.map(&String.split(&1, " -> "))
      |> Enum.map(fn l ->
        l |> Enum.map(fn c -> c |> String.split(",") |> Enum.map(&String.to_integer/1) end)
      end)
      |> Enum.map(fn set ->
        set
        |> Enum.chunk_every(2, 1)
        |> then(fn chunks -> chunks |> Enum.slice(0..(length(chunks) - 2)) end)
      end)
      |> Enum.flat_map(& &1)
      |> Enum.reduce([], fn
        [[sx, sy], [sx, ey]], acc ->
          acc ++ (sy..ey |> Enum.map(fn y -> [sx, y] end))

        [[sx, sy], [ex, sy]], acc ->
          acc ++ (sx..ex |> Enum.map(fn x -> [x, sy] end))
      end)
      |> Enum.uniq()

  defp get_below(particles, x, y),
    do:
      particles
      |> Enum.filter(&(Enum.at(&1, 0) == x))
      |> Enum.filter(&(Enum.at(&1, 1) >= y))
      |> Enum.min_by(&Enum.at(&1, 1), fn -> nil end)

  defp drop(particles, [fx, fy]) do
    if [fx - 1, fy] not in particles do
      # move to the left
      # TODO: Don't need to use fx - 1 and fy + 1 since get_below will guarantee it finds that
      if [fx - 1, fy + 1] not in particles do
        next_floor = get_below(particles, fx - 1, fy)

        if next_floor == nil do
          # no more floor below to drop to on the left
          particles
        else
          drop(particles, next_floor)
        end
      else
        drop(particles, [fx - 1, fy + 1])
      end
    else
      # move to the right
      if [fx + 1, fy] not in particles do
        if [fx + 1, fy + 1] not in particles do
          next_floor = get_below(particles, fx + 1, fy)

          if next_floor == nil do
            # no more floor below to drop to on the right
            particles
          else
            drop(particles, next_floor)
          end
        else
          drop(particles, [fx + 1, fy + 1])
        end
      else
        # can settle at the current position
        IO.puts("settle on #{inspect([fx, fy - 1])}")
        updated_particles = [[fx, fy - 1] | particles]

        drop(
          updated_particles,
          get_below(updated_particles, Enum.at(@sand_source, 0), Enum.at(@sand_source, 1))
        )
      end
    end
  end

  defp print_cave(rocks) do
    {[min_x, _], [max_x, _]} = rocks |> Enum.min_max_by(fn [x, _] -> x end)
    {_, [_, max_y]} = rocks |> Enum.min_max_by(fn [_, y] -> y end)

    0..max_y
    |> Enum.reduce("", fn y, cave ->
      line =
        min_x..max_x
        |> Enum.reduce("", fn x, line ->
          if [x, y] == @sand_source,
            do: line <> "+",
            else: if([x, y] in rocks, do: line <> "#", else: line <> ".")
        end)

      cave <> line <> "\n"
    end)
    |> IO.puts()
  end

  def solve_one() do
    collect()
    |> then(fn rocks ->
      print_cave(rocks)
      target_tile = get_below(rocks, Enum.at(@sand_source, 0), Enum.at(@sand_source, 1))

      drop(rocks, target_tile)
      |> then(fn final ->
        print_cave(final)
        final
      end)
      |> then(&(&1 -- rocks))
      |> Enum.count()
    end)
  end

  def solve_two() do
  end
end
