defmodule NflRushing.Statistics do
  import Ecto.Query

  alias NflRushing.{DataImport, Repo}
  alias NflRushing.Statistics.Player

  @type sort_order :: :asc | :desc

  @spec insert_players_from_file(binary()) ::
          {number(), [Player.t()]} | {:error, atom | Jason.DecodeError.t()}
  def insert_players_from_file(file_name) do
    with {:ok, params} <- DataImport.parse_players_from_file(file_name) do
      Repo.insert_all(Player, params, returning: true)
    end
  end

  @spec list_players(atom(), sort_order(), integer(), integer()) :: Scrivener.Page.t()
  def list_players(field, order, page, page_size) do
    Player
    |> order_by([player], {^order, field(player, ^field)})
    |> Repo.paginate(%{page: page, page_size: page_size})
  end
end
