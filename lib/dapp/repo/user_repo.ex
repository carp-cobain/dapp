defmodule Dapp.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  import Ecto.Query

  alias Algae.Either.{Left, Right}
  alias Algae.Maybe

  alias Dapp.Repo
  alias Dapp.Schema.User

  @doc "Create a user from a blockchain address or raise."
  def create!(address) do
    Repo.insert!(%User{blockchain_address: address})
  end

  @doc "Get a user by id and wrap in Either."
  def get(id) when is_nil(id) do
    {"Invalid user id: nil", 400}
    |> Left.new()
  end

  def get(id) do
    case Repo.get(User, id) do
      nil -> {"Not found", 404} |> Left.new()
      user -> Right.new(user)
    end
  end

  @doc "Query for the user with the given blockchain address."
  def get_by_address(address) do
    unless is_nil(address) do
      Repo.one(
        from(u in User,
          where: u.blockchain_address == ^address,
          select: u
        )
      )
    end
    |> Maybe.from_nillable()
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
