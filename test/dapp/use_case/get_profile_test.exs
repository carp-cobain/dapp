defmodule Dapp.UseCase.GetProfileTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}

  alias Dapp.Mock.{Audit, UserRepo}
  alias Dapp.UseCase.GetProfile

  @opts [repo: UserRepo, audit: Audit]

  # Create user and return use case context
  setup do
    addr = TestUtil.fake_address()
    params = %{blockchain_address: addr, name: "Jane Doe", email: "jane.doe@email.com"}
    %Right{right: user} = UserRepo.create(params)
    %{args: %{user_id: user.id}, blockchain_address: addr}
  end

  # GetProfile use case tests
  describe "GetProfile" do
    test "should return an existing user profile", ctx do
      assert %Right{right: dto} = GetProfile.execute(ctx, @opts)
      assert dto.profile.blockchain_address == ctx.blockchain_address
    end

    test "should return an error when a user is not found" do
      ctx = %{args: %{user_id: Nanoid.generate()}}
      assert %Left{left: {status, _error}} = GetProfile.execute(ctx, @opts)
      assert status == :not_found
    end
  end
end
