defmodule Dapp.UseCase.Role.Dto.Role do
  @moduledoc """
  Role data transfer object.
  """
  import Algae
  alias Dapp.Data.Schema.Role, as: RoleSchema
  alias Dapp.UseCase.Dto

  alias __MODULE__

  @derive Jason.Encoder
  defdata do
    id :: pos_integer()
    name :: String.t()
  end

  # Make this DTO the default for role.
  defimpl Dto, for: RoleSchema do
    def from_schema(struct) do
      Role.new(struct.id, struct.name)
    end
  end
end
