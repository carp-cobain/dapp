defmodule Dapp.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.Repo.UserRepo
  alias Ecto.Adapters.SQL.Sandbox

  # Test context
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    TestUtil.setup_user()
  end

  # Test user repo
  describe "UserRepo" do
    test "should get a user by blockchain address", ctx do
      assert %Right{right: user} = UserRepo.get_by_address(ctx.user.blockchain_address)
      assert user.id == ctx.user.id
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
