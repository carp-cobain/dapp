defmodule Dapp.UseCase.GetRolesTest do
  use ExUnit.Case, async: true

  alias Algae.Either.Right
  alias Algae.Reader

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
      use_case = GetRoles.new(RoleRepo)
      assert %Right{right: dto} = Reader.run(use_case, ctx)
      assert length(dto.roles) == 2
      assert Enum.find(dto.roles, &(&1.name == "Admin"))
      assert Enum.find(dto.roles, &(&1.name == "Viewer"))
    end
  end
end
