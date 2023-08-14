defmodule Dapp.UseCase.User.Dto.Profile do
  @moduledoc "User profile data transfer object."
  import Algae
  alias Dapp.Data.Schema.User
  alias Dapp.UseCase.Dto

  alias __MODULE__

  defdata do
    user_id :: String.t()
    blockchain_address :: String.t()
    name :: String.t()
    email :: String.t()
    role :: String.t() \\ nil
  end

  # Encoder for profile. Ignore role if not set.
  defimpl Jason.Encoder, for: Profile do
    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, get_keys(value)), opts)
    end

    defp get_keys(value) do
      if is_nil(Map.get(value, :role)) do
        [:user_id, :blockchain_address, :name, :email]
      else
        [:user_id, :blockchain_address, :name, :email, :role]
      end
    end
  end

  # Make this DTO the default for user.
  defimpl Dto, for: User do
    def from_schema(user) do
      profile = Profile.new(user.id, user.blockchain_address, user.name, user.email)

      if Ecto.assoc_loaded?(user.role) do
        %{profile | role: user.role.name}
      else
        profile
      end
    end
  end
end
