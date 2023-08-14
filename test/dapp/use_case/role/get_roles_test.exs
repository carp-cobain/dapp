defmodule Dapp.UseCase.Role.GetRolesTest do
  use ExUnit.Case, async: true

  alias Algae.Either.Right
  alias Algae.Reader

  import Hammox

  # Use case being tested
  alias Dapp.UseCase.Role.GetRoles

  # Verify mocks on exit
  setup :verify_on_exit!

  # GetRoles use case tests
  describe "GetRoles" do
    test "should return all roles" do
      RolesMock |> expect(:get_roles, &TestUtil.fake_roles/0)
      assert %Right{right: roles} = GetRoles.new(repo: RolesMock) |> Reader.run(%{})
      assert length(roles) == 2
    end
  end
end
