defmodule NflRushingWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  alias Ecto.Changeset

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  def translate_changeset_errors(changeset) do
    Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def translate_errors(target) when is_map(target) do
    target
    |> Enum.map(&translate_error_keypair/1)
    |> Map.new()
  end

  def translate_errors(target) when is_binary(target) do
    translate_error({target, []})
  end

  def translate_errors({msg, opts}) when is_binary(msg) and is_list(opts) do
    translate_error({msg, opts})
  end

  defp translate_error_keypair({key, %Ecto.Changeset{} = value}) do
    value = translate_changeset_errors(value)

    {key, value}
  end

  defp translate_error_keypair({key, value}) when is_map(value) do
    value = translate_errors(value)

    {key, value}
  end

  defp translate_error_keypair({key, value}) when is_list(value) do
    value = Enum.map(value, &translate_errors/1)

    {key, value}
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(NflRushingWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(NflRushingWeb.Gettext, "errors", msg, opts)
    end
  end
end
