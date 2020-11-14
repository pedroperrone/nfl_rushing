defmodule NflRushingWeb.Params.PlayerFilter do
  use NflRushingWeb.Params

  import EctoEnum
  defenum(SortingOrder, ["asc", "desc"])

  defenum(SortingField, [
    "name",
    "total_rushing_yards",
    "longest_rush_yards",
    "rushing_touchdowns"
  ])

  @fields [:name, :sorting_order, :sorting_field]

  embedded_schema do
    field :name, :string
    field :sorting_order, SortingOrder, default: :asc
    field :sorting_field, SortingField, default: :name
  end

  def cast(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> to_map()
  end
end
