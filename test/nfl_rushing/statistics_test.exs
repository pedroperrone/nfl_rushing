defmodule NflRushing.StatisticsTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Statistics

  describe "insert_players_from_file/1" do
    test "inserts all the given player statistics" do
      assert {4, players} = Statistics.insert_players_from_file("test/fixtures/players.json")

      Enum.each(players, fn player ->
        refute is_nil(player.id)
      end)
    end

    test "returns an error when the file does not exist" do
      assert Statistics.insert_players_from_file("inexistent.json") == {:error, :enoent}
    end

    test "returns an error when the content of the file is not a valid json" do
      assert {:error, %Jason.DecodeError{}} =
               Statistics.insert_players_from_file("test/fixtures/invalid.json")
    end
  end
end
