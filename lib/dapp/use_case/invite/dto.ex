defmodule Dapp.UseCase.Invite.Dto do
  @moduledoc """
  DTO helper functions for use cases.
  """
  alias Dapp.Dto

  @doc "Create a profile DTO from a user schema struct."
  def profile(user),
    do: %{
      profile: Dto.from_schema(user)
    }

  @doc "Create an invite DTO."
  def invite(invite),
    do: %{
      invite: Dto.from_schema(invite)
    }
end
