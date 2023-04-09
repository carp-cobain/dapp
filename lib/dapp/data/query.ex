defmodule Dapp.Data.Query do
  @moduledoc """
    Database queries for dApp.
  """
  import Ecto.Query
  alias Dapp.Data.Repo
  alias Dapp.Data.Schema.User

  # Query for the user with the given blockchain address.
  def get_user(address) do
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
  def get_user_role(user) do
    role = user_role(user)

    unless is_nil(role) do
      Map.get(role, :name)
    end
  end

  # Get the role for a user.
  defp user_role(user) do
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
