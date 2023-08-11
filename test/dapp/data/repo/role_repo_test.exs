defmodule Dapp.Data.Repo.RoleRepoTest do
  use ExUnit.Case, async: true
  alias Ecto.Adapters.SQL.Sandbox

  # Repo being tested
  alias Dapp.Data.Repo.RoleRepo

  # Set up SQL sandbox.
  setup do
    Sandbox.checkout(Dapp.Repo)
  end

  # Test that repo can query roles from the db.
  describe "RoleRepo" do
    test "should return all stored roles" do
      Enum.each(TestUtil.fake_roles(), &TestUtil.ensure_role(&1.name))
      roles = RoleRepo.get_roles()
      assert length(roles) == 2
    end
  end
end
