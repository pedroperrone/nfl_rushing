defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.Statistics
  alias NflRushingWeb.Params.PlayerFilter

  def index(conn, params) do
    with {:ok, params} <- PlayerFilter.cast(params) do
      csv =
        params.sorting_field
        |> Statistics.list_players(params.sorting_order, params.name)
        |> Statistics.players_to_csv()

      send_download(conn, {:binary, csv}, filename: "rushing.csv")
    end
  end
end
