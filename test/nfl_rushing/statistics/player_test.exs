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
end
