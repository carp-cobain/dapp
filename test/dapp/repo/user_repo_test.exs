defmodule Dapp.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.Right
  alias Dapp.Repo
  alias Dapp.Repo.UserRepo
  alias Dapp.Schema.{Grant, Role, User}
  alias Ecto.Adapters.SQL.Sandbox
  alias Nanoid.Configuration, as: NanoidConfig

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    addr = "tp#{Nanoid.generate(39)}" |> String.downcase()
    %{address: addr, role: "Test"}
  end

  # Test user repo
  describe "UserRepo" do
    test "should create and get a user by blockchain address", ctx do
      user = Repo.insert!(%User{blockchain_address: ctx.address})
      assert String.length(user.id) == NanoidConfig.default_size()
      assert is_nil(user.name) && is_nil(user.email)
      assert UserRepo.get_by_address(ctx.address) == Right.new(user)
    end

    test "should return unauthorized for users without a grant", ctx do
      user = Repo.insert!(%User{blockchain_address: ctx.address})
      assert UserRepo.access(user.id) == :unauthorized
    end

    test "should return the authorized role for users with a grant", ctx do
      user = Repo.insert!(%User{blockchain_address: ctx.address})
      role = Repo.insert!(%Role{name: ctx.role})
      Repo.insert!(%Grant{user: user, role: role})
      assert UserRepo.access(user.id) == {:authorized, ctx.role}
    end
  end
end
