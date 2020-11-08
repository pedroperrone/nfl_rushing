defmodule NflRushing.StatisticsTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Statistics

  describe "insert_players_batch/1" do
    test "inserts all the given player statistics" do
      params = Enum.map(0..2, fn _ -> params_for(:player) end)

      assert {3, players} = Statistics.insert_players_batch(params)

      Enum.each(players, fn player ->
        refute is_nil(player.id)
      end)
    end
  end
end
