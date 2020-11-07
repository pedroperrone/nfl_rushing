defmodule NflRushing.Factory do
  use ExMachina.Ecto, repo: NflRushing.Repo

  alias NflRushing.Statistics.Player

  def player_factory do
    %Player{
      name: Faker.Person.name(),
      team: Faker.Team.name(),
      position: "RB",
      average_rushing_attempts: random_float(0, 20),
      total_rushing_attempts: Enum.random(0..300),
      total_rushing_yards: random_float(0, 1500),
      average_rushing_yards: random_float(0, 10),
      average_game_yards: random_float(0, 100),
      rushing_touchdowns: Enum.random(0..15),
      longest_rush_yards: random_float(0, 100),
      touchdown_on_longest_rush: true,
      rushing_first_downs: Enum.random(0..50),
      rushing_first_down_percentage: random_float(0, 100),
      rushing_over_20_yards: Enum.random(0..15),
      rushing_over_40_yards: Enum.random(0..5),
      fumbles: Enum.random(0..5)
    }
  end

  defp random_float(min, max) do
    Float.round(min + (max - min) * :rand.uniform(), 2)
  end
end
