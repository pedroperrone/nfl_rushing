defmodule NflRushingWeb.Params do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import NflRushingWeb.Params
    end
  end

  def to_map(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.apply_action(:insert)
    |> case do
      {:ok, data} -> {:ok, to_map(data)}
      other -> other
    end
  end

  def to_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> Enum.map(&key_to_map/1)
    |> Map.new()
  end

  def to_map(struct), do: struct

  defp key_to_map({key, value}) when is_map(value) do
    value = to_map(value)

    {key, value}
  end

  defp key_to_map({key, value}) when is_list(value) do
    value = Enum.map(value, &to_map/1)

    {key, value}
  end

  defp key_to_map({key, value}), do: {key, value}
end
