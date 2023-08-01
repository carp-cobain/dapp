defmodule Dapp.UseCase.Invite.SignupTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}

  alias Dapp.Mock.{Audit, InviteRepo}
  alias Dapp.UseCase.Invite.Signup

  @opts [repo: InviteRepo, audit: Audit]

  # Create and return use case context
  setup do
    %{
      args: %{
        blockchain_address: TestUtil.fake_address(),
        name: "Jane Doe",
        email: "jane.doe@email.com",
        invite_code: Nanoid.generate()
      }
    }
  end

  # Signup use case tests
  describe "Signup" do
    # Signup success
    test "should create a user profile", ctx do
      assert %Right{right: dto} = Signup.execute(ctx, @opts)
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
