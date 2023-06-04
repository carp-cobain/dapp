defmodule Dapp.UseCase.Args do
  @moduledoc """
  Use case arguments helper functions.
  """
  alias Algae.Either.{Left, Right}
  use Witchcraft

  @doc "Wrap nillable args in an Either"
  def from_nillable(ctx) do
    if is_nil(ctx) do
      {"Invalid context: nil", 400} |> Left.new()
    else
      get_args(ctx)
    end
  end

  # Get args from context.
  defp get_args(ctx) do
    case Map.get(ctx, :args) do
      nil -> {"Invalid args: nil", 400} |> Left.new()
      args -> Right.new(args)
    end
  end

  @doc "Wrap nillable Map.get/2 in an Either"
  def get(args, key) do
    case Map.get(args, key) do
      nil -> {"Arg #{key} is required", 400} |> Left.new()
      value -> Right.new(value)
    end
  end
end
