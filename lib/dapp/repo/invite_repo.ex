defmodule Dapp.Repo.InviteRepo do
  @moduledoc """
  Onboarding repository for the dApp.
  """
  use Dapp.Error

  alias Algae.Either.Right

  alias Dapp.{Error, Repo}
  alias Dapp.Schema.{Grant, Invite, User}

  alias Ecto.Multi

  @doc "Create an invite."
  def create_invite(params) do
    %Invite{}
    |> Invite.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, invite} -> Right.new(invite)
      {:error, cs} -> Error.extract(cs) |> invalid_args()
    end
  end

  @doc "Look up an invite using id and email address."
  def get_invite(id, email) do
    case Repo.get(Invite, id) do
      nil -> Error.new("invite not found") |> not_found()
      invite -> verify_invite(invite, email)
    end
  end

  @doc "Create a user with name, email and a grant"
  def signup(params, invite, user_id \\ Nanoid.generate()) do
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
  defp grant_params(user_id, invite),
    do: %{
      user_id: user_id,
      role_id: invite.role_id,
      invite_id: invite.id
    }
end
