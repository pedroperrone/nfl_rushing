defmodule NflRushing.DataImportTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.DataImport

  describe "parse_players_from_file/1" do
    test "parses the content of the file" do
      expected_content = [
        %{
          average_game_yards: 7.0,
          average_rushing_attempts: 2.0,
          average_rushing_yards: 3.5,
          fumbles: 0,
          longest_rush_yards: 7.0,
          name: "Joe Banyard",
          position: "RB",
          rushing_first_down_percentage: 0.0,
          rushing_first_downs: 0,
          rushing_over_20_yards: 0,
          rushing_over_40_yards: 0,
          rushing_touchdowns: 0,
          team: "JAX",
          total_rushing_attempts: 2,
          total_rushing_yards: 7.0,
          touchdown_on_longest_rush: false
        },
        %{
          average_game_yards: 1.7,
          average_rushing_attempts: 1.7,
          average_rushing_yards: 1.0,
          fumbles: 0,
          longest_rush_yards: 9.0,
          name: "Shaun Hill",
          position: "QB",
          rushing_first_down_percentage: 0.0,
          rushing_first_downs: 0,
          rushing_over_20_yards: 0,
          rushing_over_40_yards: 0,
          rushing_touchdowns: 0,
          team: "MIN",
          total_rushing_attempts: 5,
          total_rushing_yards: 5.0,
          touchdown_on_longest_rush: false
        },
        %{
          average_game_yards: 0.1,
          average_rushing_attempts: 0.1,
          average_rushing_yards: 2.0,
          fumbles: 0,
          longest_rush_yards: 2,
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
        },
        %{
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
        }
      ]

      assert DataImport.parse_players_from_file("test/fixtures/players.json") ===
               {:ok, expected_content}
    end

    test "returns an error when the file does not exist" do
      assert DataImport.parse_players_from_file("inexistent.json") == {:error, :enoent}
    end

    test "returns an error when the content of the file is not a valid json" do
      assert {:error, %Jason.DecodeError{}} =
               DataImport.parse_players_from_file("test/fixtures/invalid.json")
    end
  end
end
