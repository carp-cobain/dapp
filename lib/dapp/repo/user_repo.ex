defmodule Dapp.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  import Ecto.Query

  alias Dapp.Repo
  alias Dapp.Schema.User

  @doc "Get all users"
  def all, do: Repo.all(User)

  @doc "Create a user from a blockchain address or raise."
  def create!(address) do
    Repo.insert!(%User{blockchain_address: address})
  end

  @doc "Validate and create a user from a blockchain address."
  def create(address) do
    %User{}
    |> User.changeset(%{blockchain_address: address})
    |> Repo.insert()
  end

  @doc "Query for the user with the given blockchain address."
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

  @doc "Get the access level for a user."
  def access(user_id) do
    (query_role(user_id) || %{})
    |> Map.get(:role)
    |> case do
      nil -> :unauthorized
      role -> {:authorized, role}
    end
  end

  # Helper: query for a user's role.
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
