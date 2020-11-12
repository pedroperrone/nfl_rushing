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

  describe "list_players/4" do
    test "returns the players sorted by the given field" do
      player_1 = insert(:player, name: "A")
      player_2 = insert(:player, name: "C")
      player_3 = insert(:player, name: "B")

      page = Statistics.list_players(:name, :asc, 1, 3)

      assert page.page_number == 1
      assert page.page_size == 3
      assert Enum.map(page.entries, & &1.id) == [player_1.id, player_3.id, player_2.id]
    end

    test "returns the players sorted in the given order" do
      player_1 = insert(:player, name: "A")
      player_2 = insert(:player, name: "C")
      player_3 = insert(:player, name: "B")

      page = Statistics.list_players(:name, :desc, 1, 3)

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

      page = Statistics.list_players(:average_rushing_attempts, :desc, 2, 2)

      assert page.page_number == 2
      assert page.page_size == 2
      assert Enum.map(page.entries, & &1.id) == [player_3.id, player_2.id]
    end
  end
end
