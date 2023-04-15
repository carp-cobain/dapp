defmodule Dapp.UseCase do
  @moduledoc """
  Defines use case behaviour.
  """
  @callback execute(args :: term) :: {:ok, dto :: term} | {:error, details :: term, status :: term}
end
