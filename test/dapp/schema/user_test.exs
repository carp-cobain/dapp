defmodule Dapp.Schema.UserTest do
  use ExUnit.Case, async: true
  alias Dapp.Schema.User

  # Test context
  setup do
    valid_addr = "tp#{Nanoid.generate(39)}" |> String.downcase()
    bad_prefix = "zz#{Nanoid.generate(39)}" |> String.downcase()
    too_long = "tp#{Nanoid.generate(99)}" |> String.downcase()

    %{
      valid_params: %{blockchain_address: valid_addr, name: "Jon Doe", email: "jon.doe@gmail.com"},
      valid_address: %{blockchain_address: valid_addr},
      bad_prefix: %{blockchain_address: bad_prefix},
      too_short: %{blockchain_address: "tp123skt"},
      too_long: %{blockchain_address: too_long},
      email_too_short: %{email: "a@", blockchain_address: valid_addr}
    }
  end

  # Test user changeset validations
  describe "User.changeset" do
    test "it succeeds on valid params", ctx do
      result = User.changeset(%User{}, ctx.valid_params)
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

    test "it fails when email is too short", ctx do
      result = User.changeset(%User{}, ctx.email_too_short)
      refute result.valid?
      assert result.errors[:email], "expected email error"
    end
  end
end
