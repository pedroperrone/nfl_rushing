defmodule NflRushing.Repo.Migrations.RemoveTimestamps do
  use Ecto.Migration

  def up do
    alter table(:players) do
      remove :inserted_at
      remove :updated_at
    end
  end

  def down do
    alter table(:players) do
      timestamps()
    end
  end
end
