defmodule Dapp.Mock.UserRepo do
  @moduledoc false

  alias Dapp.Mock.Db
  alias Dapp.Schema.User

  alias Algae.Either.{Left, Right}
  alias Algae.Maybe
  alias Algae.State

  use Dapp.Mock.DbState

  use Witchcraft

  # ##########################################################################
  # API
  # ##########################################################################

  # Get all users
  def all, do: Map.values(get_state())

  # Clear db state (mock repo only).
  def clear, do: put_state(%{})

  # Create a user with only a blockchain address.
  def create!(address) do
    mk_user(address, now())
    |> tap(fn user -> upsert(user.id, user) end)
  end

  # Validate and create a user.
  def create(address) do
    validate(%{blockchain_address: address}) >>>
      fn changes ->
        create!(changes.blockchain_address)
        |> Right.new()
      end
  end

  # Get a user by id.
  def get(id) do
    Db.get(id)
    |> State.evaluate(get_state())
    |> case do
      nil -> {"Not found", 404} |> Left.new()
      user -> Right.new(user)
    end
  end

  # Get a user by blockchain address.
  def get_by_address(address) do
    Db.find(:blockchain_address, address)
    |> State.evaluate(get_state())
    |> Maybe.from_nillable()
  end

  # ##########################################################################
  # Helpers
  # ##########################################################################

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

  # Create a user schema struct.
  defp mk_user(addr, ts),
    do: %User{
      id: Nanoid.generate(),
      blockchain_address: addr,
      inserted_at: ts,
      updated_at: ts
    }

  # Check that user params are valid
  defp validate(params) do
    cs = User.changeset(%User{}, params)

    if cs.valid? do
      Right.new(cs.changes)
    else
      Left.new(cs.errors)
    end
  end
end
