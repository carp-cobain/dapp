defmodule Dapp.Error do
  @moduledoc "Error support for dApp"
  import Algae

  alias Dapp.Error.BadField
  alias Dapp.Error.Message

  @doc "Error sum types"
  defsum do
    defdata Message do
      message :: String.t()
    end

    defdata BadField do
      field :: String.t()
      detail :: String.t()
    end
  end

  # Encoder for BadField
  defimpl Jason.Encoder, for: BadField do
    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, [:field, :detail]), opts)
    end
  end

  # Encoder for Message
  defimpl Jason.Encoder, for: Message do
    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, [:message]), opts)
    end
  end

  @doc "Create an error with only detail"
  def new(message), do: Message.new(message)

  @doc "Create an invalid field error"
  def new(field, detail), do: BadField.new(field, detail)

  # Guard for nil changeset.
  def extract(cs) when is_nil(cs), do: %{}

  @doc "Extract errors from an ecto change set."
  def extract(cs), do: %{details: details(cs)}

  # Extract error details from a changeset.
  defp details(cs) do
    Enum.map(
      Map.get(cs, :errors) || [],
      fn {f, d} ->
        get_bad_field(f, d)
      end
    )
  end

  # Get error field and detail.
  defp get_bad_field(f, {m, vs}) do
    {field, message} = check_override(f, m, vs)

    detail =
      Enum.reduce(vs, message, fn {k, v}, acc ->
        String.replace(acc, "%{#{k}}", to_string(v))
      end)

    BadField.new(field, detail)
  end

  # Get error detail.
  defp get_bad_field(f, s), do: BadField.new(f, s)

  # Can check for and apply error overrides here.
  # For example, ecto reports the first column on unique constraint violations over multiple columns.
  # Could return the the more useful column here for this case.
  defp check_override(field, message, _values) do
    {field, message}
  end
end
