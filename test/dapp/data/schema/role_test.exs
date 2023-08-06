defmodule Dapp.Data.Schema.RoleTest do
  use ExUnit.Case, async: true

  alias Dapp.Data.Schema.Role

  # Test context
  setup do
    %{
      valid_params: %{name: "Test"},
      empty_name: %{name: ""},
      too_long: %{name: Nanoid.generate(256)}
    }
  end

  # Test role changeset validations
  describe "Role.changeset" do
    test "it succeeds on valid params", ctx do
      result = Role.changeset(%Role{}, ctx.valid_params)
      assert result.valid?
    end

    test "it fails on missing name" do
      result = Role.changeset(%Role{}, %{})
      refute result.valid?
      assert result.errors[:name], "expected role name error"
    end

    test "it fails on empty name", ctx do
      result = Role.changeset(%Role{}, ctx.empty_name)
      refute result.valid?
      assert result.errors[:name], "expected role name error"
    end

    test "it fails on too long name", ctx do
      result = Role.changeset(%Role{}, ctx.too_long)
      refute result.valid?
      assert result.errors[:name], "expected role name error"
    end
  end
end
