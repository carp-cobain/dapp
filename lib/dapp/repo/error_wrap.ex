defmodule Dapp.Repo.ErrorWrap do
  @moduledoc """
  Macro for repo error helper functions.
  """
  defmacro __using__(_opts) do
    quote do
      alias Algae.Either.Left
      defp invalid_args(error), do: wrap_error(error, :invalid_args)
      defp not_found(error), do: wrap_error(error, :not_found)
      defp wrap_error(error, status), do: {status, error} |> Left.new()
    end
  end
end
