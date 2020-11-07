defmodule NflRushing.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :team, :string
      add :position, :string
      add :average_rushing_attempts, :float
      add :total_rushing_attempts, :integer
      add :total_rushing_yards, :float
      add :average_rushing_yards, :float
      add :average_game_yards, :float
      add :rushing_touchdowns, :integer
      add :longest_rush_yards, :float
      add :touchdown_on_longest_rush, :boolean
      add :rushing_first_downs, :integer
      add :rushing_first_down_percentage, :float
      add :rushing_over_20_yards, :integer
      add :rushing_over_40_yards, :integer
      add :fumbles, :integer

      timestamps()
    end

    create index(:players, :total_rushing_yards)
    create index(:players, :longest_rush_yards)
    create index(:players, :rushing_touchdowns)
  end
end
