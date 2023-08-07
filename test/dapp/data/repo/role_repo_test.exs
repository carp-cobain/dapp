defmodule Dapp.Data.Repo.RoleRepoTest do
  use ExUnit.Case, async: true

  alias Dapp.Data.Repo.RoleRepo
  alias Ecto.Adapters.SQL.Sandbox

  # Test context
  setup do
    Sandbox.checkout(Dapp.Repo)
  end

  # Query all roles.
  describe "RoleRepo" do
    test "should return all stored roles" do
      Enum.each(TestUtil.fake_roles(), &TestUtil.ensure_role(&1.name))
      roles = RoleRepo.get_roles()
      assert length(roles) == 2
    end
  end
end
