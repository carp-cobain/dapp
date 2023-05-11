defmodule Dapp.UseCase do
  @moduledoc """
  Defines use case behaviour.
  """
  @callback execute(args :: term) ::
              {:ok, dto :: term}
              | {:created, dto :: term}
              | :nothing
              | {:error, details :: term, status :: term}
end
