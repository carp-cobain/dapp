defmodule Dapp.Schema.UserTest do
  use ExUnit.Case, async: true
  alias Dapp.Schema.User

  setup do
    %{
      valid_address: %{blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz"},
      bad_prefix: %{blockchain_address: "zz17vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz"},
      too_short: %{blockchain_address: "tp19vd8fpwxzck93q"},
      too_long: %{blockchain_address: "tp16vd8fpwxzck93q1118vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz8vd8skz"}
    }
  end

  describe "User.changeset" do
    test "it succeeds on valid address", ctx do
      result = User.changeset(%User{}, ctx.valid_address)
      assert result.valid?
    end

    test "it fails on empty input params" do
      result = User.changeset(%User{}, %{})
      refute result.valid?
    end

    test "it fails when blockchain address prefix is invalid", ctx do
      result = User.changeset(%User{}, ctx.bad_prefix)
      refute result.valid?
      assert result.errors[:blockchain_address], "expected blockchain_address error"
    end

    test "it fails when blockchain address is too short", ctx do
      result = User.changeset(%User{}, ctx.too_short)
      refute result.valid?
      assert result.errors[:blockchain_address], "expected blockchain_address error"
    end

    test "it fails when blockchain address is too long", ctx do
      result = User.changeset(%User{}, ctx.too_long)
      refute result.valid?
      assert result.errors[:blockchain_address], "expected blockchain_address error"
    end
  end
end
