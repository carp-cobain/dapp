defmodule Dapp.UseCase do
  @moduledoc """
  Use case execution is defined as a function that takes a context (map) and a options,
  often containing a repository for DB interaction. Execution must return an error
  wrapped in `Either.Left`, or a success DTO wrapped in `Either.Right`.
  """
  @callback execute(map(), any()) :: Algae.Either.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Dapp.UseCase

      alias Algae.Reader
      use Witchcraft

      @doc "Wrap use case execution in a reader monad."
      def new(opts) do
        monad %Reader{} do
          ctx <- Reader.ask()
          return(execute(ctx, opts))
        end
      end
    end
  end
end
