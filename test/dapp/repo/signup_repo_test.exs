defmodule Dapp.Repo.SignupRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.Repo.SignupRepo
  alias Ecto.Adapters.SQL.Sandbox

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)

    # Test context
    invite = TestUtil.setup_invite()

    %{
      params: %{
        blockchain_address: TestUtil.fake_address(),
        name: "User #{Nanoid.generate(6)}",
        code: invite.id,
        email: invite.email
      },
      invite: invite
    }
  end

  # Test signup repo
  describe "SignupRepo" do
    test "should create a user with a valid invite", ctx do
      assert %Right{right: user} = SignupRepo.signup(ctx.params, ctx.invite)
      assert user.email == ctx.invite.email
    end

    test "should fail to create a user given invalid args", ctx do
      assert %Left{left: {status, _error}} = SignupRepo.signup(%{}, ctx.invite)
      assert status == :invalid_args
    end
  end
end
