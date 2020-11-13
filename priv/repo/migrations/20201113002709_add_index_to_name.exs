defmodule NflRushing.Repo.Migrations.AddIndexToName do
  use Ecto.Migration

  def change do
    create index(:players, :name)
  end
end
