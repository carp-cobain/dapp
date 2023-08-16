defmodule Dapp.UseCase.User.Dto.Profile do
  @moduledoc """
  User profile data transfer object.
  """
  import Algae
  alias Dapp.Data.Schema.User
  alias Dapp.UseCase.Dto

  alias __MODULE__

  @derive Jason.Encoder
  defdata do
    user_id :: String.t()
    blockchain_address :: String.t()
    name :: String.t()
    email :: String.t()
  end

  # Make this DTO the default for user.
  defimpl Dto, for: User do
    def from_schema(user) do
      Profile.new(user.id, user.blockchain_address, user.name, user.email)
    end
  end
end
