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

  defp get_below(particles, x, y, true, inf_floor) do
    get_below(particles, x, y, false)
    |> then(fn
      nil -> [x, inf_floor]
      val -> val
    end)
  end

  defp get_below(particles, x, y, false),
    do:
      particles
      |> Enum.filter(&(Enum.at(&1, 0) == x))
      |> Enum.filter(&(Enum.at(&1, 1) >= y))
      |> Enum.min_by(&Enum.at(&1, 1), fn -> nil end)

  defp drop(particles, nil, _), do: particles

  defp drop(particles, [fx, fy], false) do
    if [fx - 1, fy] not in particles do
      # move to the left
      next_floor = get_below(particles, fx - 1, fy, false)
      drop(particles, next_floor, false)
    else
      if [fx + 1, fy] not in particles do
        next_floor = get_below(particles, fx + 1, fy, false)
        drop(particles, next_floor, false)
      else
        # can settle at the current position
        [[fx, fy - 1] | particles]
        |> then(fn updated_particles ->
          drop(
            updated_particles,
            get_below(updated_particles, 500, 0, false),
            false
          )
        end)
      end
    end
  end

  defp drop(particles, [fx, fy], true, inf_floor) do
    if [500, 0] in particles do
      particles
    else
      # if on the infinite floor already, just settle and move on
      if fy == inf_floor do
        IO.puts("settling on infinite floor #{inspect([fx, fy])}")
        # can settle at the current position
        [[fx, fy - 1] | particles]
        |> then(fn updated_particles ->
          drop(
            updated_particles,
            get_below(updated_particles, 500, 0, true, inf_floor),
            true,
            inf_floor
          )
        end)
      else
        if [fx - 1, fy] not in particles do
          # move to the left
          next_floor = get_below(particles, fx - 1, fy, true, inf_floor)
          drop(particles, next_floor, true, inf_floor)
        else
          if [fx + 1, fy] not in particles do
            next_floor = get_below(particles, fx + 1, fy, true, inf_floor)
            drop(particles, next_floor, true, inf_floor)
          else
            # can settle at the current position
            [[fx, fy - 1] | particles]
            |> then(fn updated_particles ->
              drop(
                updated_particles,
                get_below(updated_particles, 500, 0, true, inf_floor),
                true,
                inf_floor
              )
            end)
          end
        end
      end
    end
  end

  defp print_cave(rocks, has_floor? \\ false) do
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
    |> then(fn cave ->
      if has_floor? do
        cave = cave <> (min_x..max_x |> Enum.map(fn _ -> "." end) |> Enum.join("")) <> "\n"
        cave = cave <> (min_x..max_x |> Enum.map(fn _ -> "#" end) |> Enum.join("")) <> "\n"
        cave
      else
        cave
      end
    end)
    |> IO.puts()

    rocks
  end

  def solve_one() do
    collect()
    |> then(fn rocks ->
      drop(rocks, get_below(rocks, 500, 0, false), false)
      |> print_cave()
      |> then(&(&1 -- rocks))
      |> Enum.count()
    end)
  end

  def solve_two() do
    IO.puts("solving two")

    collect()
    |> then(fn rocks ->
      print_cave(rocks, true)
      inf_floor = (Enum.max_by(rocks, &Enum.at(&1, 1)) |> Enum.at(1)) + 2

      drop(rocks, get_below(rocks, 500, 0, true, inf_floor), true, inf_floor)
      |> print_cave()
      |> then(&(&1 -- rocks))
      |> Enum.count()
    end)
  end
end
