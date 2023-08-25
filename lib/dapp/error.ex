defmodule Dapp.Error do
  @moduledoc "Error support for dApp"
  import Algae

  alias __MODULE__

  @doc "Error product type"
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

  @doc "Extract error detail from an ecto changeset."
  def extract(cs), do: %{detail: format_errors(cs)}

  # Get ecto changeset error detail.
  defp format_errors(cs) do
    Ecto.Changeset.traverse_errors(cs, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  # Common error helper functions
  defmacro __using__(_opts) do
    quote do
      alias Algae.Either.Left
      defp invalid_args(error), do: wrap_error(error, :invalid_args)
      defp not_found(error), do: wrap_error(error, :not_found)
      defp wrap_error(error, status), do: {status, error} |> Left.new()
    end
  end
end
