defmodule Dapp.UseCase.GetProfileTest do
  use ExUnit.Case, async: true

  alias Algae.Either.Right
  alias Algae.Reader

  alias Dapp.Mock.UserRepo
  alias Dapp.UseCase.GetProfile

  # Create user and return use case context
  setup do
    addr = "tp#{Nanoid.generate(39)}" |> String.downcase()
    params = %{blockchain_address: addr, name: "Jane Doe", email: "jane.doe@email.com"}
    %Right{right: user} = UserRepo.signup(params)
    %{args: %{user_id: user.id}, blockchain_address: addr}
  end

  # GetProfile use case tests
  describe "GetProfile" do
    test "should return an existing user profile (monad reader)", ctx do
      use_case = GetProfile.new(UserRepo)
      assert %Right{right: dto} = Reader.run(use_case, ctx)
      assert dto.profile.blockchain_address == ctx.blockchain_address
    end

    test "should return an existing user profile (partial application)", ctx do
      use_case = GetProfile.execute(UserRepo)
      assert %Right{right: dto} = use_case.(ctx)
      assert dto.profile.blockchain_address == ctx.blockchain_address
    end

    test "monad reader result should match execute result", ctx do
      use_case = GetProfile.new(UserRepo)
      assert Reader.run(use_case, ctx) == GetProfile.execute(UserRepo, ctx)
    end
  end
end
