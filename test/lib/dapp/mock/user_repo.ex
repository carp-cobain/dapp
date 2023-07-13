defmodule Dapp.Mock.UserRepo do
  @moduledoc """
  A fake user repo that allows testing use cases without a DB connection.
  """
  alias Algae.Either.{Left, Right}
  use Witchcraft

  alias Dapp.Error
  alias Dapp.Schema.User

  alias Dapp.Mock.Db
  use Dapp.Mock.DbState

  # Test only
  def create(params) do
    validate(params) >>>
      fn user ->
        Db.upsert(user.id, user) |> exec() |> put_state()
        Right.new(user)
      end
  end

  # Get a user by id.
  def get(id) do
    Db.get(id)
    |> eval()
    |> either()
  end

  # Get a user by blockchain address.
  def get_by_address(address) do
    Db.find(:blockchain_address, address)
    |> eval()
    |> either()
  end

  # Wrap user in the either type.
  defp either(user) do
    if is_nil(user) do
      {:not_found, Error.new("user not found")} |> Left.new()
    else
      Right.new(user)
    end
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
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)
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
