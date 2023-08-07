defmodule Dapp.Data.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.Data.Repo.UserRepo
  alias Ecto.Adapters.SQL.Sandbox

  # Test context
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    TestUtil.setup_user()
  end

  # Test user repo
  describe "UserRepo" do
    test "should get a user by user_id", ctx do
      assert %Right{right: user} = UserRepo.get_user(ctx.user.id)
      assert user.blockchain_address == ctx.user.blockchain_address
    end

    test "should return an error when a user is not found" do
      user_id = Nanoid.generate()
      assert %Left{left: {status, _error}} = UserRepo.get_user(user_id)
      assert status == :not_found
    end

    test "should return an error when a nil user_id is passed" do
      assert %Left{left: {status, _error}} = UserRepo.get_user(nil)
      assert status == :invalid_args
    end

    test "should get a user by blockchain address", ctx do
      assert %Right{right: user} = UserRepo.get_user_by_address(ctx.user.blockchain_address)
      assert user.id == ctx.user.id
    end

    test "should return an error when a user is not found by blockchain address" do
      addr = TestUtil.fake_address()
      assert %Left{left: {status, _error}} = UserRepo.get_user_by_address(addr)
      assert status == :not_found
    end

    test "should return an error when a nil blockchain address is passed" do
      assert %Left{left: {status, _error}} = UserRepo.get_user_by_address(nil)
      assert status == :invalid_args
    end
  end
end
