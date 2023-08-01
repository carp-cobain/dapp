defmodule Dapp.UseCase.Role.Dto do
  @moduledoc """
  DTO helper functions for use cases.
  """
  alias Dapp.Dto

  @doc "Create role list DTO from a list of schema structs."
  def roles(roles),
    do: %{
      roles: Enum.map(roles, &Dto.from_schema/1)
    }
end
