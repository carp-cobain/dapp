defmodule Dapp.UseCase.SignupTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}

  alias Dapp.Mock.{Audit, SignupRepo}
  alias Dapp.UseCase.Signup

  @opts [repo: SignupRepo, audit: Audit]

  # Create and return use case context
  setup do
    %{
      args: %{
        blockchain_address: TestUtil.fake_address(),
        name: "Jane Doe",
        email: "jane.doe@email.com",
        code: Nanoid.generate()
      }
    }
  end

  # Signup use case tests
  describe "Signup" do
    # Signup success
    test "should create user profile", ctx do
      assert %Right{right: dto} = Signup.execute(ctx, @opts)
      assert dto.profile.blockchain_address == ctx.args.blockchain_address
      assert dto.profile.name == ctx.args.name
      assert dto.profile.email == ctx.args.email
    end

    # Signup failure
    test "should fail to create user profile with bad args" do
      ctx = %{args: %{}}
      assert %Left{left: {status, _error}} = Signup.execute(ctx, @opts)
      assert status == :invalid_args
    end
  end
end
