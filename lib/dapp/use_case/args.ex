defmodule Dapp.UseCase.Args do
  @moduledoc """
  Use case arguments helper functions.
  """
  alias Algae.Either.{Left, Right}
  alias Dapp.Error
  use Witchcraft

  # Handle nil context with error.
  def from_nillable(ctx) when is_nil(ctx) do
    Error.new("invalid use case context: nil")
    |> fail()
  end

  @doc "Wrap nillable args in an Either"
  def from_nillable(ctx) do
    case Map.get(ctx, :args) do
      nil -> Error.new("invalid use case args: nil") |> fail()
      args -> pure(args)
    end
  end

  @doc "Get a required arg value from a context."
  def get(ctx, key, default \\ nil) do
    from_nillable(ctx) >>>
      fn args ->
        get_arg(args, key, default)
      end
  end

  # Try get arg value, return in Either.
  defp get_arg(args, key, default \\ nil) do
    case Map.get(args, key) || default do
      nil -> Error.new("use case arg is required", key) |> fail()
      value -> pure(value)
    end
  end

  # Guard for nil keys
  def take(_ctx, keys) when is_nil(keys) do
    Error.new("nil keys")
    |> fail()
  end

  # Guard for empty keys
  def take(_ctx, []) do
    Error.new("empty keys")
    |> fail()
  end

  @doc "Get a tuple of required arg values"
  def take(ctx, keys) do
    from_nillable(ctx) >>>
      fn args ->
        take_args(args, keys)
      end
  end

  # Take helper
  defp take_args(args, keys) do
    keys
    ~> fn key -> get_arg(args, key) end
    |> sequence() >>>
      fn list ->
        left_fold(list, {}, &Tuple.append/2)
        |> pure()
      end
  end

  @doc "Extract key-value params from a context."
  def params(ctx, keys) do
    take(ctx, keys) >>>
      fn vals ->
        List.zip([keys, vals])
        |> Map.new()
        |> pure()
      end
  end

  # Wrap value in right.
  defp pure(value), do: Right.new(value)

  # Wrap error with status in left.
  defp fail(error), do: {:invalid_args, error} |> Left.new()
end
