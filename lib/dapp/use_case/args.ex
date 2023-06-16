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
    |> failure()
  end

  @doc "Wrap nillable args in an Either"
  def from_nillable(ctx) do
    case Map.get(ctx, :args) do
      nil -> Error.new("invalid use case args: nil") |> failure()
      args -> success(args)
    end
  end

  @doc "Get a required arg value"
  def required(args, key) do
    case Map.get(args, key) do
      nil -> Error.new("use case arg is required", key) |> failure()
      value -> success(value)
    end
  end

  @doc "Get a tuple of required arg values"
  def take(args, keys) do
    keys ~> (&required(args, &1)) |> sequence() >>>
      fn list ->
        left_fold(list, {}, &Tuple.append/2)
        |> success()
      end
  end

  # Wrap value in right.
  defp success(value), do: Right.new(value)

  # Wrap error with 400 in left.
  defp failure(error), do: {error, 400} |> Left.new()
end
