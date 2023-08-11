defmodule Dapp.UseCase do
  @moduledoc """
  Use case execution is defined as a function that takes two arguments - a
  context map and options keyword list. The context must contain an args map
  taken from a http request, or unit test. Options will usually contain data
  API abstractions for DB or web-service interaction. Execution must return
  an error wrapped in `Either.Left`, or a success DTO wrapped in `Either.Right`.
  """
  @doc false
  defmacro __using__(_opts) do
    quote do
      alias Algae.Either.{Left, Right}
      alias Algae.Reader
      use Dapp.Auditable
      use Witchcraft

      @before_compile Dapp.UseCase

      @doc "Wrap use case execution in a reader monad."
      def new(opts) do
        monad %Reader{} do
          ctx <- Reader.ask()
          return(execute(ctx, opts))
        end
      end

      @doc false
      defp pure(value), do: Right.new(value)

      @doc false
      defp fail(error, status \\ :internal_error) do
        {status, error} |> Left.new()
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
