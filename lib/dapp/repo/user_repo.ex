defmodule Dapp.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  alias Ecto.Multi
  import Ecto.Query

  alias Algae.Either.{Left, Right}

  alias Dapp.Error
  alias Dapp.Repo
  alias Dapp.Schema.{Grant, Role, User}

  # Required role granted upon signup.
  @signup_role Application.compile_env(:dapp, :signup_role)

  @doc "Create a user with name, email and a grant"
  def signup(params) do
    case Repo.get_by(Role, name: @signup_role) do
      nil -> {:internal_error, Error.new("internal error: required role not found")} |> Left.new()
      role -> signup(params, role.id, Nanoid.generate())
    end
  end

  # Signup helper
  defp signup(params, role_id, user_id) do
    Multi.new()
    |> Multi.insert(:user, User.changeset(%User{id: user_id}, params))
    |> Multi.insert(:grant, Grant.changeset(%Grant{}, %{user_id: user_id, role_id: role_id}))
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

  # Error helper for bad requests
  defp invalid_args(error), do: wrap_error(error, :invalid_args)

  # Error helper for not found
  defp not_found(error), do: wrap_error(error, :not_found)

  # Error helper
  defp wrap_error(error, status), do: {status, error} |> Left.new()
end
