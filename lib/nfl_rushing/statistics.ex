defmodule NflRushing.Statistics do
  import Ecto.Query

  alias NflRushing.{CSV, DataImport, Repo}
  alias NflRushing.Statistics.Player

  @type sort_order :: :asc | :desc

  @spec insert_players_from_file(binary(), integer()) ::
          {number(), nil} | {:error, atom | Jason.DecodeError.t()}
  def insert_players_from_file(file_name, batch_size \\ 500) do
    with {:ok, params} <- DataImport.parse_players_from_file(file_name) do
      params
      |> Enum.chunk_every(batch_size)
      |> Enum.map(&Repo.insert_all(Player, &1))
      |> Enum.reduce({0, nil}, fn {inserted_rows, second_term}, {accumulator, _} ->
        {accumulator + inserted_rows, second_term}
      end)
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

  @spec players_to_csv([Player.t()]) :: binary()
  def players_to_csv(players) do
    headers = [
      name: "Player",
      team: "Team",
      position: "Pos",
      average_rushing_attempts: "Att/G",
      total_rushing_attempts: "Att",
      total_rushing_yards: "Yds",
      average_rushing_yards: "Avg",
      average_game_yards: "Yds/G",
      rushing_touchdowns: "TD",
      longest_rush_with_touchdown: "Lng",
      rushing_first_downs: "1st",
      rushing_first_down_percentage: "1st%",
      rushing_over_20_yards: "20+",
      rushing_over_40_yards: "40+",
      fumbles: "FUM"
    ]

    players
    |> Stream.map(&Player.put_longest_rush_with_touchdown/1)
    |> CSV.from_maps(headers)
  end
end
