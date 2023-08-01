defmodule Dapp.UseCase.Role.GetRolesTest do
  use ExUnit.Case, async: true

  alias Algae.Either.Right

  alias Dapp.Mock.RoleRepo
  alias Dapp.UseCase.Role.GetRoles

  # Create roles and return empty use case context.
  setup do
    RoleRepo.insert(1, "Root")
    RoleRepo.insert(2, "User")
    %{}
  end

  # GetRoles use case tests
  describe "GetRoles" do
    test "should return all roles", ctx do
      assert %Right{right: dto} = GetRoles.execute(ctx, repo: RoleRepo)
      assert length(dto.roles) == 2
      assert Enum.find(dto.roles, &(&1.name == "Root"))
      assert Enum.find(dto.roles, &(&1.name == "User"))
    end
  end
end
