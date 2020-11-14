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

  @spec list_players(atom(), sort_order(), integer(), integer(), binary() | nil) ::
          Scrivener.Page.t()
  def list_players(ordering_field, order, page, page_size, name_filter) do
    Player
    |> players_query(ordering_field, order, name_filter)
    |> Repo.paginate(%{page: page, page_size: page_size})
  end

  @spec list_players(atom(), sort_order(), binary() | nil) :: [Player.t()]
  def list_players(ordering_field, order, name_filter) do
    Player
    |> players_query(ordering_field, order, name_filter)
    |> Repo.all()
  end

  @spec players_query(Ecto.Queryable.t(), atom(), sort_order(), binary()) :: Ecto.Query.t()
  defp players_query(query, ordering_field, order, name_filter) do
    query
    |> order_by([player], {^order, field(player, ^ordering_field)})
    |> apply_name_filter(name_filter)
  end

  @spec apply_name_filter(Ecto.Query.t(), binary()) :: Ecto.Query.t()
  defp apply_name_filter(query, nil), do: query

  defp apply_name_filter(query, name_filter) do
    ilike_pattern = "%#{name_filter}%"

    where(query, [player], ilike(player.name, fragment("?", ^ilike_pattern)))
  end
end
