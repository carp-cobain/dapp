defmodule Dapp.UseCase do
  @moduledoc """
  Defines use case behaviour.
  """
  @callback execute(args :: map) ::
              :ok | {:ok, dto :: map} | {:created, dto :: map} | {:error, details :: map, status :: integer}
end
