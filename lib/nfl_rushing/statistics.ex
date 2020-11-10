defmodule NflRushing.Statistics do
  alias NflRushing.{DataImport, Repo}
  alias NflRushing.Statistics.Player

  @spec insert_players_from_file(binary()) ::
          {number(), [Player.t()]} | {:error, atom | Jason.DecodeError.t()}
  def insert_players_from_file(file_name) do
    with {:ok, params} <- DataImport.parse_players_from_file(file_name) do
      Repo.insert_all(Player, params, returning: true)
    end
  end
end
