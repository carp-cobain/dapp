defmodule Dapp.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
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
    %{address: addr, role: "Test-#{Nanoid.generate(6)}"}
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
      role = Repo.insert!(%Role{name: ctx.role})
      user = Repo.insert!(%User{blockchain_address: ctx.address})
      Repo.insert!(%Grant{user: user, role: role})
      assert UserRepo.access(user.id) == {:authorized, ctx.role}
    end

    test "it should return an error when a user is not found" do
      user_id = Nanoid.generate()
      assert %Left{left: {error, status}} = UserRepo.get(user_id)
      assert error.message == "user not found: #{user_id}"
      assert status == :not_found
    end

    test "it should return an error when an invalid user_id is passed" do
      assert %Left{left: {error, status}} = UserRepo.get(nil)
      assert error.message == "user_id cannot be nil"
      assert status == :invalid_args
    end
  end
end
