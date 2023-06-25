defmodule Dapp.UseCase do
  @moduledoc """
  Define use case behaviour.
  """
  @callback execute(map(), any()) :: Algae.Either.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Dapp.UseCase

      alias Algae.Reader
      use Witchcraft

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
