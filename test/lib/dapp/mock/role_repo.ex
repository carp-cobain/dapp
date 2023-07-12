defmodule Dapp.Mock.RoleRepo do
  @moduledoc """
  A fake role repo that allows testing use cases without a DB connection.
  """
  alias Algae.Either.{Left, Right}
  use Witchcraft

  alias Dapp.Error
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

  # Remove a role
  def delete(id) do
    Db.get(id) |> eval() |> delete_role()
  end

  # Can't delete when role not found.
  defp delete_role(role) when is_nil(role) do
    {:not_found, Error.new("role not found")}
    |> Left.new()
  end

  # Delete a found role.
  defp delete_role(role) do
    Db.delete(role.id) |> exec() |> put_state()
    Right.new(role)
  end
end
