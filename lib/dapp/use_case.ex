defmodule Dapp.UseCase do
  @moduledoc """
  Use case execution is defined as a function that takes two arguments - a
  context (map) and options, often containing a repository for DB interaction.
  Execution must return an error wrapped in `Either.Left`, or a success DTO
  wrapped in `Either.Right`.
  """
  @doc false
  defmacro __using__(_opts) do
    quote do
      @before_compile Dapp.UseCase

      alias Algae.Reader
      use Dapp.Auditable
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

  @doc false
  defmacro __before_compile__(env) do
    unless Module.defines?(env.module, {:execute, 2}) do
      raise "execute not defined in module #{inspect(env.module)} using Dapp.UseCase"
    end
  end
end
