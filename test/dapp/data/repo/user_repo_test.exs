defmodule Dapp.Data.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Algae.Maybe.{Just, Nothing}
  alias Dapp.Data.Repo.UserRepo
  alias Dapp.Data.Schema.User
  alias Dapp.Repo
  alias Ecto.Adapters.SQL.Sandbox

  # Test context
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    addr = TestUtil.fake_address()
    user = Repo.insert!(%User{blockchain_address: addr})

    Map.merge(
      TestUtil.setup_user(),
      %{user_without_grant: user}
    )
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

    test "it should return the role for a user with a grant", ctx do
      assert UserRepo.get_role(ctx.user.id) == %Just{just: ctx.role_name}
    end

    test "it should return nothing for a user without a grant", ctx do
      assert UserRepo.get_role(ctx.user_without_grant.id) == %Nothing{}
    end

    test "it should return nothing for a non-existing user" do
      assert UserRepo.get_role(Nanoid.generate()) == %Nothing{}
      assert UserRepo.get_role(nil) == %Nothing{}
    end
  end
end
