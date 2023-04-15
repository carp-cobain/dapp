defmodule Dapp.Data.Repo.UserRepo do
  @moduledoc """
  User queries for dApp.
  """
  import Ecto.Query
  alias Dapp.Data.Repo
  alias Dapp.Data.Schema.User

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

  # Get the role name for a user.
  def role(user) do
    role = query_role(user)

    unless is_nil(role) do
      Map.get(role, :name)
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
          select: %{name: r.name}
        )
      )
    end
  end
end
