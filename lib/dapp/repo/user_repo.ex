defmodule Dapp.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  alias Ecto.Multi
  import Ecto.Query

  alias Algae.Either.{Left, Right}

  alias Dapp.Error
  alias Dapp.Repo
  alias Dapp.Schema.{Grant, Invite, User}

  @doc "Look up an invite using id and email address."
  def invite(id, email) do
    case Repo.get(Invite, id) do
      nil -> Error.new("invite not found") |> not_found()
      invite -> verify_invite(invite, email)
    end
  end

  @doc "Create a user with name, email and a grant"
  def signup(params, invite), do: signup(params, invite, Nanoid.generate())

  # Signup helper
  defp signup(params, invite, user_id) do
    Multi.new()
    |> Multi.insert(:user, User.changeset(%User{id: user_id}, params))
    |> Multi.insert(:grant, Grant.changeset(%Grant{}, grant_params(user_id, invite)))
    |> Multi.update(:invite, Invite.changeset(invite, %{consumed_at: now()}))
    |> Repo.transaction()
    |> case do
      {:ok, result} -> Right.new(result.user)
      {:error, _name, cs, _changes_so_far} -> Error.extract(cs) |> invalid_args()
    end
  end

  # Return error on nil user id.
  def get(user_id) when is_nil(user_id) do
    Error.new("user_id cannot be nil")
    |> invalid_args()
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
    Error.new("address cannot be nil")
    |> invalid_args()
  end

  @doc "Query for the user with the given blockchain address."
  def get_by_address(address) do
    Repo.one(
      from(u in User,
        where: u.blockchain_address == ^address,
        select: u
      )
    )
    |> case do
      nil -> Error.new("user not found: #{address}") |> not_found()
      user -> Right.new(user)
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

  # Verify an invite is for the provided email.
  defp verify_invite(invite, email) do
    if invite.email == email && is_nil(invite.consumed_at) do
      Right.new(invite)
    else
      Error.new("invite not found")
      |> not_found()
    end
  end

  # Current timestamp
  defp now do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end

  # Build grant param map for insert
  defp grant_params(user_id, invite) do
    %{user_id: user_id, role_id: invite.role_id, invite_id: invite.id}
  end

  # Error helper for bad requests
  defp invalid_args(error), do: wrap_error(error, :invalid_args)

  # Error helper for not found
  defp not_found(error), do: wrap_error(error, :not_found)

  # Error helper
  defp wrap_error(error, status), do: {status, error} |> Left.new()
end
