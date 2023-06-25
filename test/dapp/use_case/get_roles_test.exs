defmodule Dapp.UseCase.GetRolesTest do
  use ExUnit.Case, async: true

  alias Algae.Either.Right

  alias Dapp.Mock.RoleRepo
  alias Dapp.UseCase.GetRoles

  # Create roles and return empty use case context.
  setup do
    RoleRepo.insert(1, "Admin")
    RoleRepo.insert(2, "Viewer")
    %{}
  end

  # GetRoles use case tests
  describe "GetRoles" do
    test "should return all roles", ctx do
      assert %Right{right: dto} = GetRoles.execute(ctx, RoleRepo)
      assert length(dto.roles) == 2
      assert Enum.find(dto.roles, &(&1.name == "Admin"))
      assert Enum.find(dto.roles, &(&1.name == "Viewer"))
    end
  end
end
