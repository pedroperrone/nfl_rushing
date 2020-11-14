defmodule NflRushing.StatisticsTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Statistics

  describe "insert_players_from_file/2" do
    test "inserts all the given player statistics" do
      assert Statistics.insert_players_from_file("test/fixtures/players.json") == {4, nil}
    end

    test "inserts correctly when the amount of players exceeds batch size" do
      assert Statistics.insert_players_from_file("test/fixtures/players.json", 3) == {4, nil}
    end

    test "returns an error when the file does not exist" do
      assert Statistics.insert_players_from_file("inexistent.json") == {:error, :enoent}
    end

    test "returns an error when the content of the file is not a valid json" do
      assert {:error, %Jason.DecodeError{}} =
               Statistics.insert_players_from_file("test/fixtures/invalid.json")
    end
  end

  describe "list_players/5" do
    test "returns the players sorted by the given field when the name filter is nil" do
      player_1 = insert(:player, name: "A")
      player_2 = insert(:player, name: "C")
      player_3 = insert(:player, name: "B")

      page = Statistics.list_players(:name, :asc, 1, 3, nil)

      assert page.page_number == 1
      assert page.page_size == 3
      assert Enum.map(page.entries, & &1.id) == [player_1.id, player_3.id, player_2.id]
    end

    test "returns the players sorted by the given field and filtered by name" do
      player_1 = insert(:player, name: "xAx")
      player_2 = insert(:player, name: "yax")
      _player_3 = insert(:player, name: "B")

      page = Statistics.list_players(:name, :asc, 1, 3, "a")

      assert page.page_number == 1
      assert page.page_size == 3
      assert page.total_entries == 2
      assert Enum.map(page.entries, & &1.id) == [player_1.id, player_2.id]
    end

    test "returns the players sorted in the given order" do
      player_1 = insert(:player, name: "A")
      player_2 = insert(:player, name: "C")
      player_3 = insert(:player, name: "B")

      page = Statistics.list_players(:name, :desc, 1, 3, nil)

      assert page.page_number == 1
      assert page.page_size == 3
      assert Enum.map(page.entries, & &1.id) == [player_2.id, player_3.id, player_1.id]
    end

    test "paginates correctly" do
      _player_1 = insert(:player, average_rushing_attempts: 1)
      player_2 = insert(:player, average_rushing_attempts: 2)
      player_3 = insert(:player, average_rushing_attempts: 3)
      _player_4 = insert(:player, average_rushing_attempts: 4)
      _player_5 = insert(:player, average_rushing_attempts: 5)

      page = Statistics.list_players(:average_rushing_attempts, :desc, 2, 2, nil)

      assert page.page_number == 2
      assert page.page_size == 2
      assert Enum.map(page.entries, & &1.id) == [player_3.id, player_2.id]
    end
  end

  describe "list_players/3" do
    test "returns the players sorted by the given field when the name filter is nil" do
      player_1 = insert(:player, name: "A")
      player_2 = insert(:player, name: "C")
      player_3 = insert(:player, name: "B")

      players = Statistics.list_players(:name, :asc, nil)

      assert Enum.map(players, & &1.id) == [player_1.id, player_3.id, player_2.id]
    end

    test "returns the players sorted by the given field and filtered by name" do
      player_1 = insert(:player, name: "xAx")
      player_2 = insert(:player, name: "yax")
      _player_3 = insert(:player, name: "B")

      players = Statistics.list_players(:name, :asc, "a")

      assert Enum.map(players, & &1.id) == [player_1.id, player_2.id]
    end

    test "returns the players sorted in the given order" do
      player_1 = insert(:player, name: "A")
      player_2 = insert(:player, name: "C")
      player_3 = insert(:player, name: "B")

      players = Statistics.list_players(:name, :desc, nil)

      assert Enum.map(players, & &1.id) == [player_2.id, player_3.id, player_1.id]
    end
  end

  describe "players_to_csv/2" do
    test "generates a csv from the players content" do
      player_1 =
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

      player_2 =
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

      assert Statistics.players_to_csv([player_1, player_2]) == csv_content
    end
  end
end
