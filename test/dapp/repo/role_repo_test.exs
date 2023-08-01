defmodule Dapp.Repo.RoleRepoTest do
  use ExUnit.Case, async: true

  alias Dapp.Repo.RoleRepo
  alias Ecto.Adapters.SQL.Sandbox

  # Test context
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    TestUtil.ensure_role("Root")
    TestUtil.ensure_role("User")
    :ok
  end

  describe "RoleRepo" do
    test "should return all stored roles" do
      roles = RoleRepo.get_roles()
      assert length(roles) == 2
    end
  end
end
