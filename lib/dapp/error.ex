defmodule Dapp.Error do
  @moduledoc "Error support for dApp"
  import Algae

  alias __MODULE__

  @doc "Error sum types"
  defdata do
    message :: String.t()
    field :: atom() \\ nil
  end

  # Encoder for errors
  defimpl Jason.Encoder, for: Error do
    def encode(value, opts) do
      keys = if is_nil(Map.get(value, :field)), do: [:message], else: [:message, :field]
      Jason.Encode.map(Map.take(value, keys), opts)
    end
  end

  # Guard for nil changeset.
  def extract(cs) when is_nil(cs), do: %{}

  @doc "Extract errors from an ecto change set."
  def extract(cs), do: %{details: details(cs)}

  # Extract error details from a changeset.
  defp details(cs) do
    Enum.map(
      Map.get(cs, :errors) || [],
      fn {f, d} ->
        get_field_detail(f, d)
      end
    )
  end

  # Get error field and detail.
  defp get_field_detail(f, {m, vs}) do
    {field, message} = check_override(f, m, vs)

    detail =
      Enum.reduce(vs, message, fn {k, v}, acc ->
        String.replace(acc, "%{#{k}}", to_string(v))
      end)

    Error.new(detail, field)
  end

  # Get error detail.
  defp get_field_detail(f, s), do: Error.new(s, f)

  # Can check for and apply error overrides here.
  # For example, ecto reports the first column on unique constraint violations over multiple columns.
  # Could return the the more useful column here for this case.
  defp check_override(field, message, _values) do
    {field, message}
  end
end
