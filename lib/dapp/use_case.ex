defmodule Dapp.UseCase do
  @moduledoc """
  Use case execution is defined as a function that takes a context (map) and a second
  parameter, often a repository for DB interaction. Execution must return an error
  wrapped in `Either.Left`, or a success DTO wrapped in `Either.Right`.
  """
  @callback execute(map(), any()) :: Algae.Either.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Dapp.UseCase

      alias Dapp.UseCase
      import Quark.Partial
      use Witchcraft

      @doc """
      Allow partial application of use case execution.
      Params are flipped so callers can close over a repo before executing with a context.
      """
      defpartial new(repo, ctx) do
        execute(ctx, repo)
      end
    end
  end
end
