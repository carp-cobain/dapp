defmodule Dapp.Data.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  @behaviour Dapp.Data.Api.Users
  use Dapp.Error

  alias Algae.Either.Right
  alias Algae.Maybe

  alias Dapp.Data.Schema.User
  alias Dapp.{Error, Repo}

  import Ecto.Query

  @doc "Get the role for a user with a grant."
  def get_role(user_id) do
    (query_role(user_id) || %{})
    |> Map.get(:role)
    |> Maybe.from_nillable()
  end

  # Return error on nil user id.
  def get(user_id) when is_nil(user_id) do
    Error.new("user_id cannot be nil") |> invalid_args()
  end

  @doc "Get a user by id and wrap in Either."
  def get(user_id) do
    case Repo.get(User, user_id) do
      nil -> Error.new("user not found: #{user_id}") |> not_found()
      user -> Right.new(user)
    end
  end

  # Return error on nil address.
  def get_by_address(address) when is_nil(address) do
    Error.new("address cannot be nil") |> invalid_args()
  end

  @doc "Query for the user with the given blockchain address."
  def get_by_address(address) do
    case Repo.get_by(User, blockchain_address: address) do
      nil -> Error.new("user not found: #{address}") |> not_found()
      user -> Right.new(user)
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
