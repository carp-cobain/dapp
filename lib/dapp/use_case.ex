defmodule Dapp.UseCase do
  @moduledoc """
  Define use case behaviour.
  """
  @callback execute(map(), any()) :: Algae.Either.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Dapp.UseCase

      alias Algae.Reader
      import Quark.Partial
      use Witchcraft

      @doc """
      Allow partial application of use case execution.
      Params are flipped so callers can close over a repo before executing with a context.
      """
      defpartial apply(repo, ctx) do
        execute(ctx, repo)
      end

      @doc "Wrap use case execution in a reader monad."
      def new(repo) do
        monad %Reader{} do
          ctx <- Reader.ask()
          return(execute(ctx, repo))
        end
      end
    end
  end
end
