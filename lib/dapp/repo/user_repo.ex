defmodule Dapp.Repo.UserRepo do
  @moduledoc """
  User queries for dApp.
  """
  import Ecto.Query

  alias Dapp.Repo
  alias Dapp.Schema.User

  # Query all users
  def all, do: Repo.all(User)

  # Create a user from a blockchain address or raise.
  def create!(address) do
    Repo.insert!(%User{blockchain_address: address})
  end

  # Validate and create a user from a blockchain address.
  def create(address) do
    %User{}
    |> User.changeset(%{blockchain_address: address})
    |> Repo.insert()
  end

  # Query for the user with the given blockchain address.
  def get(address) do
    unless is_nil(address) do
      Repo.one(
        from(u in User,
          where: u.blockchain_address == ^address,
          select: u
        )
      )
    end
  end

  # Get user access level.
  def access(user_id) do
    (query_role(user_id) || %{})
    |> Map.get(:role)
    |> case do
      nil -> :unauthorized
      role -> {:authorized, role}
    end
  end

  # Query for a user's role.
  defp query_role(user_id) do
    unless is_nil(user_id) do
      Repo.one(
        from(r in "roles",
          join: g in "grants",
          on: g.role_id == r.id,
          where: g.user_id == ^user_id,
          select: %{role: r.name}
        )
      )
    end
  end
end
