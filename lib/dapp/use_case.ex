defmodule Dapp.UseCase do
  # Defines use case shape.
  @callback execute(args :: term) :: {:ok, msg :: term} | {:error, msg :: term, status :: term}
end
