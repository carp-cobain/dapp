defmodule Dapp.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Dapp.Repo
  alias Dapp.Repo.UserRepo
  alias Dapp.Schema.{Grant, Role}
  alias Ecto.Adapters.SQL.Sandbox
  alias Nanoid.Configuration, as: NanoidConfig

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    %{address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz", role: "Test"}
  end

  # Test user repo
  describe "UserRepo" do
    test "should create and get a user using only a blockchain address", ctx do
      user = UserRepo.create!(ctx.address)
      assert String.length(user.id) == NanoidConfig.default_size()
      assert is_nil(user.name) && is_nil(user.email)
      assert UserRepo.get(ctx.address) == user
    end

    test "should return unauthorized for users without a grant", ctx do
      user = UserRepo.create!(ctx.address)
      assert UserRepo.access(user) == :unauthorized
    end

    test "should return the authorized role for users with a grant", ctx do
      user = UserRepo.create!(ctx.address)
      role = Repo.insert!(%Role{name: ctx.role})
      Repo.insert!(%Grant{user: user, role: role})
      assert UserRepo.access(user) == {:authorized, ctx.role}
    end
  end
end
