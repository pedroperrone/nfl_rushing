defmodule NflRushing.DataImport do
  def parse_players_from_file(filename) do
    with {:ok, file_content} <- File.read(filename),
         {:ok, decoded_content} <- Jason.decode(file_content) do
      Enum.map(decoded_content, &parse_content/1)
    end
  end

  defp parse_content(content) do
    %{}
    |> extract(:name, "Player", content)
    |> extract(:team, "Team", content)
    |> extract(:position, "Pos", content)
    |> extract(:average_rushing_attempts, "Att/G", content)
    |> extract(:total_rushing_attempts, "Att", content)
    |> extract(:total_rushing_yards, "Yds", content, &parse_float/1)
    |> extract(:average_rushing_yards, "Avg", content)
    |> extract(:average_game_yards, "Yds/G", content)
    |> extract(:rushing_touchdowns, "TD", content)
    |> extract(:longest_rush_yards, "Lng", content, &extract_longest_run/1)
    |> extract(:touchdown_on_longest_rush, "Lng", content, &extract_touchdown_on_longest_run/1)
    |> extract(:rushing_first_downs, "1st", content)
    |> extract(:rushing_first_down_percentage, "1st%", content)
    |> extract(:rushing_over_20_yards, "20+", content)
    |> extract(:rushing_over_40_yards, "40+", content)
    |> extract(:fumbles, "FUM", content)
  end

  defp extract(map, key, path, content, modifier \\ & &1) do
    value = content |> Map.get(path) |> modifier.()

    Map.put(map, key, value)
  end

  defp parse_float(string) when is_binary(string) do
    string
    |> String.replace(",", "")
    |> Float.parse()
    |> case do
      {longest_run, ""} -> longest_run
      _ -> nil
    end
  end

  defp parse_float(float), do: float

  defp extract_longest_run(longest_run_string) when is_binary(longest_run_string) do
    longest_run_string
    |> String.replace("T", "")
    |> parse_float()
  end

  defp extract_longest_run(longest_run), do: longest_run

  defp extract_touchdown_on_longest_run(longest_run_string) when is_binary(longest_run_string) do
    String.ends_with?(longest_run_string, "T")
  end

  defp extract_touchdown_on_longest_run(_), do: false
end
