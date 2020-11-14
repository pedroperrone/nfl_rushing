defmodule NflRushing.CSVTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.CSV

  describe "from_maps/2" do
    test "builds the csv correctly" do
      maps = [
        %{
          first_key: "First first",
          second_key: "First second",
          third_key: 1
        },
        %{
          first_key: "Second first",
          second_key: "Second second",
          third_key: 2
        },
        %{
          first_key: "Third first",
          second_key: "Third second",
          third_key: 3
        }
      ]

      headers = [first_key: "Column A", second_key: "Column B", third_key: "Column C"]

      expected_output =
        Enum.join(
          [
            "Column A,Column B,Column C",
            "First first,First second,1",
            "Second first,Second second,2",
            "Third first,Third second,3"
          ],
          "\n"
        )

      assert CSV.from_maps(maps, headers) == expected_output
    end
  end
end
