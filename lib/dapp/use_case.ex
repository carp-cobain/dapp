defmodule Dapp.UseCase do
  # Defines use case shape.
  @callback execute(args :: term) :: {:ok, dto :: term} | {:error, details :: term, status :: term}
end
