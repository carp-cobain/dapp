defmodule Dapp.Repo.RoleRepoTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Repo
  alias Dapp.Repo.RoleRepo
  alias Dapp.Schema.Role

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    ensure_role("Admin")
    ensure_role("Viewer")
    :ok
  end

  # Make sure a role exists in the DB.
  defp ensure_role(name) do
    if is_nil(Repo.get_by(Role, name: name)) do
      Repo.insert!(%Role{name: name})
    end
  end

  describe "RoleRepo" do
    test "should return all stored roles" do
      roles = RoleRepo.get_roles()
      assert length(roles) == 2
    end
  end
end
