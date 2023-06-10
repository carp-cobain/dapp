defmodule Dapp.UseCase.Args do
  @moduledoc """
  Use case arguments helper functions.
  """
  alias Dapp.Error

  alias Algae.Either.{Left, Right}
  use Witchcraft

  # Handle nil context with error.
  def from_nillable(ctx) when is_nil(ctx) do
    Error.new("invalid use case context: nil")
    |> bad_request()
  end

  @doc "Wrap nillable args in an Either"
  def from_nillable(ctx) do
    case Map.get(ctx, :args) do
      nil -> Error.new("invalid use case args: nil") |> bad_request()
      args -> Right.new(args)
    end
  end

  @doc "Wrap nillable Map.get/2 in an Either"
  def required(args, key) do
    case Map.get(args, key) do
      nil -> Error.new(key, "use case arg is required") |> bad_request()
      value -> Right.new(value)
    end
  end

  # Wrap error with 400
  defp bad_request(error), do: {error, 400} |> Left.new()
end
