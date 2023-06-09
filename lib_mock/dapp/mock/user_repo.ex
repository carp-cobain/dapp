defmodule Dapp.Mock.UserRepo do
  @moduledoc false

  alias Dapp.Error
  alias Dapp.Mock.Db
  alias Dapp.Schema.User
  use Dapp.Mock.DbState

  alias Algae.Either.{Left, Right}
  alias Algae.State
  use Witchcraft

  # ##########################################################################
  # API
  # ##########################################################################

  # Validate and create a user with a name and email.
  def signup(params) do
    validate(params) >>>
      fn user ->
        upsert(user.id, user)
        Right.new(user)
      end
  end

  # Handle get for nil user id.
  def get(id) when is_nil(id) do
    {Error.wrap("Invalid user id: nil"), 400}
    |> Left.new()
  end

  # Get a user by id.
  def get(id) do
    Db.get(id)
    |> State.evaluate(get_state())
    |> either()
  end

  # Handle a nil user by blockchain address.
  def get_by_address(address) when is_nil(address) do
    {Error.wrap("Invalid address: nil"), 400}
    |> Left.new()
  end

  # Get a user by blockchain address.
  def get_by_address(address) do
    Db.find(:blockchain_address, address)
    |> State.evaluate(get_state())
    |> either()
  end

  # ##########################################################################
  # Helpers
  # ##########################################################################

  # Wrap user in a Left when nil.
  defp either(user) when is_nil(user) do
    {Error.wrap("User not found"), 404}
    |> Left.new()
  end

  # Wrap user in a Right.
  defp either(user), do: Right.new(user)

  # Create helper
  defp upsert(pk, row) do
    Db.upsert(pk, row)
    |> State.execute(get_state())
    |> put_state()
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
    cs = now() |> mk_user() |> User.changeset(params)

    if cs.valid? do
      Ecto.Changeset.apply_changes(cs) |> Right.new()
    else
      {Error.details(cs), 400} |> Left.new()
    end
  end
end
