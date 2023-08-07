defmodule Dapp.Data.Repo.InviteRepo do
  @moduledoc """
  Onboarding repository for the dApp.
  """
  @behaviour Dapp.Data.Api.Invites
  use Dapp.Error

  alias Algae.Either.Right

  alias Dapp.{Error, Repo}
  alias Dapp.Data.Schema.{Invite, User}

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
  def signup(params, invite) do
    user_id = Nanoid.generate()

    Multi.new()
    |> Multi.insert(:user, User.changeset(%User{id: user_id, role_id: invite.role_id}, params))
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
      Error.new("invite not found") |> not_found()
    end
  end

  # Current timestamp
  defp now, do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
end
