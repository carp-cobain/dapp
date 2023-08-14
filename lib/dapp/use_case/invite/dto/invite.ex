defmodule Dapp.UseCase.Invite.Dto.Invite do
  @moduledoc "Invite data transfer object."
  import Algae
  alias Dapp.Data.Schema.Invite, as: InviteSchema
  alias Dapp.UseCase.Dto

  alias __MODULE__

  @derive Jason.Encoder
  defdata do
    invite_code :: String.t()
    email :: String.t()
  end

  # Make this DTO the default for invite.
  defimpl Dto, for: InviteSchema do
    def from_schema(struct) do
      Invite.new(struct.id, struct.email)
    end
  end
end
