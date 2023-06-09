defmodule Dapp.Mock.SignupRepo do
  @moduledoc """
  A fake user repo that allows testing use cases without a DB connection.
  """
  alias Algae.Either.{Left, Right}
  use Witchcraft

  alias Dapp.Error
  alias Dapp.Schema.{Invite, User}

  alias Dapp.Mock.Db
  use Dapp.Mock.DbState

  # Validate and create a user with a name and email.
  def signup(params, _invite) do
    validate(params) >>>
      fn user ->
        Db.upsert(user.id, user) |> exec() |> put_state()
        Right.new(user)
      end
  end

  # Just return an invite
  def invite(code, email) do
    %Invite{
      id: code,
      email: email,
      role_id: 1,
      inserted_at: now(),
      updated_at: now()
    }
    |> Right.new()
  end

  # Current time
  defp now do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end

  # Create a user schema struct with defaults generated.
  defp mk_user(ts),
    do: %User{
      id: Nanoid.generate(),
      inserted_at: ts,
      updated_at: ts
    }

  # Check that user params are valid and return either user or errors.
  defp validate(params) do
    cs =
      now()
      |> mk_user()
      |> User.changeset(params)

    if cs.valid? do
      Ecto.Changeset.apply_changes(cs)
      |> Right.new()
    else
      {:invalid_args, Error.extract(cs)}
      |> Left.new()
    end
  end
end
