defmodule Dapp.Mock.UserRepo do
  @moduledoc """
  A fake user repo that allows testing use cases without a DB connection.
  """
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

  # Get a user by id.
  def get(id) do
    Db.get(id)
    |> eval()
    |> either()
  end

  # Get a user by blockchain address.
  def get_by_address(address) do
    find(address)
    |> eval()
    |> either()
  end

  # Compose/Pointfree experiments...
  # import Quark.Compose
  # import Quark.Pointfree
  # use Witchcraft, except: [<~>: 2]
  # defx get_pf, do: ((&Db.get/1) <~> (&eval/1) <~> (&either/1)).()
  # defx get_by_address_pf, do: ((&find/1) <~> (&eval/1) <~> (&either/1)).()

  # ##########################################################################
  # Helpers
  # ##########################################################################

  # State evaluation helper
  defp eval(op), do: State.evaluate(op, get_state())

  # State execution helper
  defp exec(op), do: State.execute(op, get_state())

  # Get a user by blockchain address.
  defp find(address), do: Db.find(:blockchain_address, address)

  # Wrap user in a Left when nil.
  defp either(user) when is_nil(user) do
    {Error.new("user not found"), 404}
    |> Left.new()
  end

  # Wrap user in a Right.
  defp either(user), do: Right.new(user)

  # Create helper
  def upsert(pk, user) do
    Db.upsert(pk, user)
    |> exec()
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
    cs =
      now()
      |> mk_user()
      |> User.changeset(params)

    if cs.valid? do
      Ecto.Changeset.apply_changes(cs)
      |> Right.new()
    else
      {Error.extract(cs), 400}
      |> Left.new()
    end
  end
end
