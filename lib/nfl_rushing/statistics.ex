defmodule NflRushing.Statistics do
  alias NflRushing.Repo
  alias NflRushing.Statistics.Player

  @spec insert_players_batch([map()]) :: {number(), [Player.t()]}
  def insert_players_batch(params) do
    Repo.insert_all(Player, params, returning: true)
  end
end
