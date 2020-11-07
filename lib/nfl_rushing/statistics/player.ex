defmodule NflRushing.Statistics.Player do
  use NflRushing, :schema

  @fields [
    :name,
    :team,
    :position,
    :average_rushing_attempts,
    :total_rushing_attempts,
    :total_rushing_yards,
    :average_rushing_yards,
    :average_game_yards,
    :rushing_touchdowns,
    :longest_rush_yards,
    :touchdown_on_longest_rush,
    :rushing_first_downs,
    :rushing_first_down_percentage,
    :rushing_over_20_yards,
    :rushing_over_40_yards,
    :fumbles
  ]

  schema "players" do
    field :name, :string
    field :team, :string
    field :position, :string
    field :average_rushing_attempts, :float
    field :total_rushing_attempts, :integer
    field :total_rushing_yards, :float
    field :average_rushing_yards, :float
    field :average_game_yards, :float
    field :rushing_touchdowns, :integer
    field :longest_rush_yards, :float
    field :touchdown_on_longest_rush, :boolean
    field :rushing_first_downs, :integer
    field :rushing_first_down_percentage, :float
    field :rushing_over_20_yards, :integer
    field :rushing_over_40_yards, :integer
    field :fumbles, :integer

    timestamps()
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, @fields)
    |> validate_length(:name, max: 255)
    |> validate_length(:team, max: 255)
    |> validate_length(:position, max: 255)
  end
end
