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

    test "marks longest runs with touchdowns", %{conn: conn} do
      insert(:player, longest_rush_yards: 53, touchdown_on_longest_rush: true)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index))

      assert html =~ "53.0T"
    end

    test "uses the provided page", %{conn: conn} do
      [player | _players] = 21 |> insert_list(:player) |> Enum.sort_by(& &1.name, &>=/2)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index, page: 2))

      assert html =~ player.id
    end

    test "use page one if provided page is not a valid number", %{conn: conn} do
      [_ | players] = 21 |> insert_list(:player) |> Enum.sort_by(& &1.name, &>=/2)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index, page: "a"))

      player_ids =
        players
        |> Enum.reverse()
        |> Enum.map(& &1.id)

      assert_html_includes_strings_in_order(html, player_ids)
    end

    test "changes the page on click", %{conn: conn} do
      [player | _players] = 21 |> insert_list(:player) |> Enum.sort_by(& &1.name, &>=/2)

      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index, page: 2))

      assert index_live
             |> element("#page-2")
             |> render_click() =~ player.id
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

    test "applies name filter when filter form is submited", %{conn: conn} do
      player_1 = insert(:player, name: "A")
      player_2 = insert(:player, name: "ba")
      player_3 = insert(:player, name: "b")
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      html =
        index_live
        |> form("#name-filter-form", name_filter: %{name_filter: "a"})
        |> render_submit()

      player_ids = [player_1.id, player_2.id]
      assert_html_includes_strings_in_order(html, player_ids)
      refute html =~ player_3.id
    end

    test "shows all pages when there are enough to paginate", %{conn: conn} do
      insert_list(100, :player)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index, page: 3))

      pages_ids = [
        "page-Previous",
        "page-1",
        "page-2",
        "page-3",
        "page-4",
        "page-5",
        "page-Next"
      ]

      assert_html_includes_strings_in_order(html, pages_ids)
    end

    test "does not show pages with distance bigger than two from current page", %{conn: conn} do
      insert_list(80, :player)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index, page: 1))

      refute html =~ "page-4"
    end

    test "does not show previous page button when in first page", %{conn: conn} do
      insert(:player)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index, page: 1))

      refute html =~ "page-Previous"
    end

    test "does not show next page button when in last page", %{conn: conn} do
      insert(:player)

      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index, page: 1))

      refute html =~ "page-Next"
    end
  end
end
