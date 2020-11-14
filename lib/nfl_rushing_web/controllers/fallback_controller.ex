defmodule NflRushingWeb.FallbackController do
  use NflRushingWeb, :controller

  alias Ecto.Changeset
  alias NflRushingWeb.ErrorView

  def call(conn, {:error, changeset = %Changeset{valid?: false}}) do
    errors = translate_changeset_errors(changeset)

    conn
    |> put_root_layout(false)
    |> put_status(:unprocessable_entity)
    |> put_resp_content_type("application/json")
    |> put_view(ErrorView)
    |> render("errors.json", %{errors: errors})
  end
end
