defmodule NflRushing.Statistics.PlayerTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Statistics.Player

  describe "changeset/2" do
    test "returns a valid changeset for valid params" do
      params = params_for(:player)
      changeset = Player.changeset(%Player{}, params)

      assert changeset.valid?
    end

    test "returns an invalid changeset for long strings" do
      params =
        params_for(:player,
          name: Faker.Lorem.characters(256) |> to_string(),
          team: Faker.Lorem.characters(256) |> to_string(),
          position: Faker.Lorem.characters(256) |> to_string()
        )

      changeset = Player.changeset(%Player{}, params)

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["should be at most 255 character(s)"],
               position: ["should be at most 255 character(s)"],
               team: ["should be at most 255 character(s)"]
             }
    end
  end

  describe "put_longest_rush_with_touchdown/1" do
    test "puts a T on the end of the string if tha player has a touchdown on longest rush" do
      player =
        :player
        |> build(longest_rush_yards: 50.0, touchdown_on_longest_rush: true)
        |> Player.put_longest_rush_with_touchdown()

      assert player.longest_rush_with_touchdown == "50.0T"
    end

    test "only converts the longest rush to string when there isn't a touchdown" do
      player =
        :player
        |> build(longest_rush_yards: 50.0, touchdown_on_longest_rush: false)
        |> Player.put_longest_rush_with_touchdown()

      assert player.longest_rush_with_touchdown == "50.0"
    end
  end
end
