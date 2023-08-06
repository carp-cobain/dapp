defmodule Dapp.Data.Repo.SignupRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.Data.Repo.InviteRepo
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
        invite_code: invite.id,
        email: invite.email
      },
      invite: invite
    }
  end

  # Test signup repo
  describe "InviteRepo" do
    test "should create a user with a valid invite", ctx do
      assert %Right{right: user} = InviteRepo.signup(ctx.params, ctx.invite)
      assert user.email == ctx.invite.email
    end

    test "should fail to create a user given invalid args", ctx do
      assert %Left{left: {status, _error}} = InviteRepo.signup(%{}, ctx.invite)
      assert status == :invalid_args
    end
  end
end
