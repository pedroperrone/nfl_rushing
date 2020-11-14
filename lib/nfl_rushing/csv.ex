defmodule NflRushing.CSV do
  @column_separator ","

  @spec from_maps([map()], [{atom(), binary()}]) :: binary()
  def from_maps(maps, headers) do
    Enum.join([build_header(headers), build_body(maps, headers)], "\n")
  end

  defp build_header(headers) do
    headers
    |> Enum.map(fn {_key, value} -> value end)
    |> Enum.join(@column_separator)
  end

  defp build_body(maps, headers) do
    header_keys = Enum.map(headers, fn {key, _value} -> key end)

    maps
    |> Enum.map(&build_row(&1, header_keys))
    |> Enum.join("\n")
  end

  defp build_row(map, header_keys) do
    header_keys
    |> Enum.map(&Map.get(map, &1))
    |> Enum.join(@column_separator)
  end
end
