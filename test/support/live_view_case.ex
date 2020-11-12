defmodule NflRushingWeb.LiveViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use NflRushingWeb.ConnCase
      import Phoenix.LiveViewTest

      def assert_html_includes_strings_in_order(html, strings) do
        regex =
          strings
          |> Enum.join(".*")
          |> Regex.compile!()

        assert html =~ regex
      end
    end
  end
end
