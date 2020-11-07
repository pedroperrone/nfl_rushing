defmodule NflRushing do
  defmacro __using__(which) when is_atom(which), do: apply(__MODULE__, which, [])

  def schema do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
