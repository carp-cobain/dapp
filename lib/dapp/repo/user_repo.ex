defmodule Dapp.Repo.UserRepo do
  @moduledoc """
  User queries for dApp.
  """
  import Ecto.Query

  alias Dapp.Repo
  alias Dapp.Schema.User

  # Query all users
  def all, do: Repo.all(User)

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
  def access(user) do
    (query_role(user) || %{})
    |> Map.get(:role)
    |> case do
      nil -> :unauthorized
      role -> {:authorized, role}
    end
  end

  # Query for a user's role.
  defp query_role(user) do
    unless is_nil(user) do
      Repo.one(
        from(r in "roles",
          join: g in "grants",
          on: g.role_id == r.id,
          where: g.user_id == ^user.id,
          select: %{role: r.name}
        )
      )
    end
  end
end
