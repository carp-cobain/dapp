defmodule Dapp.Error do
  @moduledoc """
  Error helper functions.
  """

  @doc "Wrap an error with only detail"
  def wrap(message), do: wrap(nil, message)

  @doc "Wrap an invalid field error"
  def wrap(field, detail), do: %{details: [%{field: field, detail: detail}]}

  # nil case handling.
  def details(cs) when is_nil(cs), do: %{details: []}

  @doc "Extract error details from an ecto change set."
  def details(cs) do
    %{
      details:
        Enum.map(
          Map.get(cs, :errors) || [],
          fn {f, d} ->
            get_field_detail(f, d)
          end
        )
    }
  end

  # Get error field and detail.
  defp get_field_detail(f, {m, vs}) do
    {field, message} = check_override(f, m, vs)

    detail =
      Enum.reduce(vs, message, fn {k, v}, acc ->
        String.replace(acc, "%{#{k}}", to_string(v))
      end)

    %{field: field, detail: detail}
  end

  # Get error detail.
  defp get_field_detail(f, s), do: {f, s}

  # Can check for and apply error overrides here.
  # For example, ecto reports the first column on unique constraint violations over multiple columns.
  # Could return the the more useful column here for this case.
  defp check_override(field, message, _values) do
    {field, message}
  end
end
