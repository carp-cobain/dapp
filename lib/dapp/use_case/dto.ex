defmodule Dapp.UseCase.Dto do
  @moduledoc """
  DTO helper functions for use cases.
  """
  alias Dapp.Data.Domain

  @doc "Create a profile DTO from a user schema struct."
  def profile(user),
    do: %{
      profile: Domain.from_schema(user)
    }

  @doc "Create an invite DTO."
  def invite(invite),
    do: %{
      invite: Domain.from_schema(invite)
    }

  @doc "Create role list DTO from a list of schema structs."
  def roles(roles),
    do: %{
      roles: Enum.map(roles, &Domain.from_schema/1)
    }
end
