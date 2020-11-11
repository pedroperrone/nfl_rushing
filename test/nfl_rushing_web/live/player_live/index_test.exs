defmodule NflRushingWeb.PlayerLive.IndexTest do
  use NflRushingWeb.LiveViewCase

  describe "Index" do
    test "lists players paginated and sorted by name", %{conn: conn} do
      [_ | players] = 21 |> insert_list(:player) |> Enum.sort_by(& &1.name, &>=/2)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index))

      player_ids =
        players
        |> Enum.reverse()
        |> Enum.map(& &1.id)

      assert_html_includes_strings_in_order(html, player_ids)
    end

    test "applies sorting changes when sort form is submited", %{conn: conn} do
      player_1 = insert(:player, longest_rush_yards: 1)
      player_2 = insert(:player, longest_rush_yards: 2)
      player_3 = insert(:player, longest_rush_yards: 3)
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      html =
        index_live
        |> form("#sorting-form",
          sorting: %{sorting_order: "desc", sorting_field: "longest_rush_yards"}
        )
        |> render_submit()

      player_ids = [player_3.id, player_2.id, player_1.id]
      assert_html_includes_strings_in_order(html, player_ids)
    end
  end
end
