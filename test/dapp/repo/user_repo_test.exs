defmodule Dapp.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.Repo
  alias Dapp.Repo.UserRepo
  alias Dapp.Schema.User
  alias Ecto.Adapters.SQL.Sandbox

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    addr = "tp#{Nanoid.generate(39)}" |> String.downcase()
    user = Repo.insert!(%User{blockchain_address: addr})
    %{address: addr, role: "Test-#{Nanoid.generate(6)}", user: user}
  end

  # Test user repo
  describe "UserRepo" do
    test "should get a user by blockchain address", ctx do
      assert UserRepo.get_by_address(ctx.address) == Right.new(ctx.user)
    end

    test "it should return an error when a user is not found" do
      user_id = Nanoid.generate()
      assert %Left{left: {status, _error}} = UserRepo.get(user_id)
      assert status == :not_found
    end

    test "it should return an error when an invalid user_id is passed" do
      assert %Left{left: {status, _error}} = UserRepo.get(nil)
      assert status == :invalid_args
    end

    test "it should return an error when a nil address is passed" do
      assert %Left{left: {status, _error}} = UserRepo.get_by_address(nil)
      assert status == :invalid_args
    end
  end
end
