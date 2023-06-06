defmodule Dapp.Dto.User do
  @moduledoc "User data transfer object."
  import Algae
  alias Dapp.Dto.User, as: UserDto

  @derive Jason.Encoder
  defdata do
    id :: String.t()
    blockchain_address :: String.t()
    name :: String.t()
    email :: String.t()
  end

  @doc "Create a user DTO from schema struct."
  def from_schema(u) do
    UserDto.new(u.id, u.blockchain_address, u.name, u.email)
  end
end
