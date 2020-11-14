defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase, async: true

  describe "GET index" do
    test "sorts data asc and by name if no params are given", %{conn: conn} do
      insert(:player,
        average_game_yards: 0.1,
        average_rushing_attempts: 0.1,
        average_rushing_yards: 2.0,
        fumbles: 0,
        longest_rush_yards: 2.0,
        name: "Breshad Perriman",
        position: "WR",
        rushing_first_down_percentage: 0.0,
        rushing_first_downs: 0,
        rushing_over_20_yards: 0,
        rushing_over_40_yards: 0,
        rushing_touchdowns: 0,
        team: "BAL",
        total_rushing_attempts: 1,
        total_rushing_yards: 2.0,
        touchdown_on_longest_rush: false
      )

      insert(:player,
        average_game_yards: 65.2,
        average_rushing_attempts: 12.8,
        average_rushing_yards: 5.1,
        fumbles: 2,
        longest_rush_yards: 75.0,
        name: "Mark Ingram",
        position: "RB",
        rushing_first_down_percentage: 23.9,
        rushing_first_downs: 49,
        rushing_over_20_yards: 4,
        rushing_over_40_yards: 2,
        rushing_touchdowns: 6,
        team: "NO",
        total_rushing_attempts: 205,
        total_rushing_yards: 1043.0,
        touchdown_on_longest_rush: true
      )

      csv_content =
        Enum.join(
          [
            "Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,TD,Lng,1st,1st%,20+,40+,FUM",
            "Breshad Perriman,BAL,WR,0.1,1,2.0,2.0,0.1,0,2.0,0,0.0,0,0,0",
            "Mark Ingram,NO,RB,12.8,205,1043.0,5.1,65.2,6,75.0T,49,23.9,4,2,2"
          ],
          "\n"
        )

      assert csv_content ==
               conn
               |> get(Routes.player_path(conn, :index))
               |> response(200)
    end

    test "sorts data desc params are given", %{conn: conn} do
      insert(:player,
        average_game_yards: 0.1,
        average_rushing_attempts: 0.1,
        average_rushing_yards: 2.0,
        fumbles: 0,
        longest_rush_yards: 2.0,
        name: "Breshad Perriman",
        position: "WR",
        rushing_first_down_percentage: 0.0,
        rushing_first_downs: 0,
        rushing_over_20_yards: 0,
        rushing_over_40_yards: 0,
        rushing_touchdowns: 0,
        team: "BAL",
        total_rushing_attempts: 1,
        total_rushing_yards: 2.0,
        touchdown_on_longest_rush: false
      )

      insert(:player,
        average_game_yards: 65.2,
        average_rushing_attempts: 12.8,
        average_rushing_yards: 5.1,
        fumbles: 2,
        longest_rush_yards: 75.0,
        name: "Mark Ingram",
        position: "RB",
        rushing_first_down_percentage: 23.9,
        rushing_first_downs: 49,
        rushing_over_20_yards: 4,
        rushing_over_40_yards: 2,
        rushing_touchdowns: 6,
        team: "NO",
        total_rushing_attempts: 205,
        total_rushing_yards: 1043.0,
        touchdown_on_longest_rush: true
      )

      csv_content =
        Enum.join(
          [
            "Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,TD,Lng,1st,1st%,20+,40+,FUM",
            "Mark Ingram,NO,RB,12.8,205,1043.0,5.1,65.2,6,75.0T,49,23.9,4,2,2",
            "Breshad Perriman,BAL,WR,0.1,1,2.0,2.0,0.1,0,2.0,0,0.0,0,0,0"
          ],
          "\n"
        )

      assert csv_content ==
               conn
               |> get(Routes.player_path(conn, :index, sorting_order: "desc"))
               |> response(200)
    end

    test "sorts data by longest_rush_yards when the params are given", %{conn: conn} do
      insert(:player,
        average_game_yards: 0.1,
        average_rushing_attempts: 0.1,
        average_rushing_yards: 2.0,
        fumbles: 0,
        longest_rush_yards: 2.0,
        name: "Breshad Perriman",
        position: "WR",
        rushing_first_down_percentage: 0.0,
        rushing_first_downs: 0,
        rushing_over_20_yards: 0,
        rushing_over_40_yards: 0,
        rushing_touchdowns: 0,
        team: "BAL",
        total_rushing_attempts: 1,
        total_rushing_yards: 2.0,
        touchdown_on_longest_rush: false
      )

      insert(:player,
        average_game_yards: 65.2,
        average_rushing_attempts: 12.8,
        average_rushing_yards: 5.1,
        fumbles: 2,
        longest_rush_yards: 75.0,
        name: "Mark Ingram",
        position: "RB",
        rushing_first_down_percentage: 23.9,
        rushing_first_downs: 49,
        rushing_over_20_yards: 4,
        rushing_over_40_yards: 2,
        rushing_touchdowns: 6,
        team: "NO",
        total_rushing_attempts: 205,
        total_rushing_yards: 1043.0,
        touchdown_on_longest_rush: true
      )

      csv_content =
        Enum.join(
          [
            "Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,TD,Lng,1st,1st%,20+,40+,FUM",
            "Breshad Perriman,BAL,WR,0.1,1,2.0,2.0,0.1,0,2.0,0,0.0,0,0,0",
            "Mark Ingram,NO,RB,12.8,205,1043.0,5.1,65.2,6,75.0T,49,23.9,4,2,2"
          ],
          "\n"
        )

      assert csv_content ==
               conn
               |> get(Routes.player_path(conn, :index, sorting_field: "longest_rush_yards"))
               |> response(200)
    end

    test "filters by name when the params are given", %{conn: conn} do
      insert(:player,
        average_game_yards: 0.1,
        average_rushing_attempts: 0.1,
        average_rushing_yards: 2.0,
        fumbles: 0,
        longest_rush_yards: 2.0,
        name: "Breshad Perriman",
        position: "WR",
        rushing_first_down_percentage: 0.0,
        rushing_first_downs: 0,
        rushing_over_20_yards: 0,
        rushing_over_40_yards: 0,
        rushing_touchdowns: 0,
        team: "BAL",
        total_rushing_attempts: 1,
        total_rushing_yards: 2.0,
        touchdown_on_longest_rush: false
      )

      insert(:player,
        average_game_yards: 65.2,
        average_rushing_attempts: 12.8,
        average_rushing_yards: 5.1,
        fumbles: 2,
        longest_rush_yards: 75.0,
        name: "Mark Ingram",
        position: "RB",
        rushing_first_down_percentage: 23.9,
        rushing_first_downs: 49,
        rushing_over_20_yards: 4,
        rushing_over_40_yards: 2,
        rushing_touchdowns: 6,
        team: "NO",
        total_rushing_attempts: 205,
        total_rushing_yards: 1043.0,
        touchdown_on_longest_rush: true
      )

      csv_content =
        Enum.join(
          [
            "Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,TD,Lng,1st,1st%,20+,40+,FUM",
            "Mark Ingram,NO,RB,12.8,205,1043.0,5.1,65.2,6,75.0T,49,23.9,4,2,2"
          ],
          "\n"
        )

      assert csv_content ==
               conn
               |> get(Routes.player_path(conn, :index, name: "mark"))
               |> response(200)
    end

    test "returns unprocessable entity when the params are not castable", %{conn: conn} do
      assert response =
               conn
               |> get(
                 Routes.player_path(conn, :index,
                   sorting_field: "invalid",
                   sorting_order: "invalid"
                 )
               )
               |> json_response(422)

      assert response == %{
               "errors" => %{"sorting_field" => ["is invalid"], "sorting_order" => ["is invalid"]}
             }
    end
  end
end
