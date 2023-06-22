defmodule Dapp.Mock.RoleRepo do
  @moduledoc """
  A fake role repo that allows testing use cases without a DB connection.
  """
  alias Algae.Either.Right
  use Witchcraft

  alias Dapp.Schema.Role

  alias Dapp.Mock.Db
  use Dapp.Mock.DbState

  # Get all roles from state.
  def get_roles, do: Map.values(get_state())

  # Add a role to the mock state db.
  def insert(id, name) do
    role = %Role{id: id, name: name}
    Db.upsert(id, role) |> exec() |> put_state()
    Right.new(role)
  end

  # Remove all roles from the mock state db.
  def clear do
    Map.new() |> put_state()
  end
end
