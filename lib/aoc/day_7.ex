defmodule AOC.Day7 do
  defp collect(),
    do:
      AOC.Utils.load_day(7)
      |> build_folder_structure()
      |> Enum.map(fn {folder, files} -> {folder, files |> Map.values() |> Enum.sum()} end)
      |> compute_total_folder_sizes()

  defp compute_total_folder_sizes(folder_structure),
    do:
      folder_structure
      |> Enum.map(fn {folder, total_size} ->
        subfolder_size =
          folder_structure
          |> Enum.filter(&String.ends_with?(elem(&1, 0), folder))
          |> Enum.filter(&(elem(&1, 0) != folder))
          |> Map.new()
          |> Map.values()
          |> Enum.sum()

        subfolder_size + total_size
      end)

  defp build_breadcrumbs(directories), do: directories |> Enum.join("-")

  defp build_folder_structure(commands), do: build_folder_structure(commands, %{}, [])

  defp build_folder_structure([], structure, _), do: structure

  defp build_folder_structure(["$ cd .." | rest], structure, [_ | previous_directories]),
    do: build_folder_structure(rest, structure, previous_directories)

  defp build_folder_structure(["$ cd " <> directory | rest], structure, directories),
    do: build_folder_structure(rest, structure, [directory | directories])

  defp build_folder_structure(["$ ls" | rest], structure, directories),
    do:
      build_folder_structure(
        rest,
        structure |> Map.put_new(build_breadcrumbs(directories), %{}),
        directories
      )

  defp build_folder_structure(["dir " <> _ | rest], structure, directories),
    do: build_folder_structure(rest, structure, directories)

  defp build_folder_structure([file | rest], structure, directories) do
    [file_size, file_name] = file |> String.split(" ")

    build_folder_structure(
      rest,
      structure
      |> Map.update!(build_breadcrumbs(directories), fn old ->
        old |> Map.put(file_name, file_size |> String.to_integer())
      end),
      directories
    )
  end

  def solve_one() do
    collect()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def solve_two() do
    sorted_sizes = collect() |> Enum.sort(:desc)
    root_size = sorted_sizes |> Enum.at(0)
    to_remove = abs(70_000_000 - root_size - 30_000_000)
    sorted_sizes |> Enum.filter(&(&1 >= to_remove)) |> Enum.min()
  end
end
