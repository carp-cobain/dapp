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

  @doc "Extract errors from an ecto change set."
  def extract(cs), do: %{details: details(cs)}

  # Extract error details from a changeset.
  defp details(cs) do
    Enum.map(
      Map.get(cs, :errors) || [],
      fn {f, d} ->
        reduce_error(f, d)
      end
    )
  end

  # Get error field and detail.
  defp reduce_error(field, {message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
    |> Error.new(field)
  end

  # Get error detail.
  defp reduce_error(field, message), do: Error.new(message, field)

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
