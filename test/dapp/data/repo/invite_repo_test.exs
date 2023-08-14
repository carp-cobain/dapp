defmodule Dapp.Data.Repo.InviteRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Ecto.Adapters.SQL.Sandbox

  # Repo being tested
  alias Dapp.Data.Repo.InviteRepo

  # Setup test context
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
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
    test "get an existing invite", ctx do
      assert %Right{right: found} = InviteRepo.get_invite(ctx.invite.id, ctx.invite.email)
      assert found == ctx.invite
    end

    test "should fail to get a non-existing invite" do
      {code, email} = {Nanoid.generate(), TestUtil.fake_email()}
      assert %Left{left: {status, _error}} = InviteRepo.get_invite(code, email)
      assert status == :not_found
    end

    test "should create an invite with valid params" do
      {email, role} = {TestUtil.fake_email(), TestUtil.ensure_role()}
      assert %Right{right: invite} = InviteRepo.create_invite(%{email: email, role_id: role.id})
      assert invite.email == email
    end

    test "should fail to create an invite with empty params" do
      assert %Left{left: {status, _error}} = InviteRepo.create_invite(%{})
      assert status == :invalid_args
    end

    test "should create a user with a valid invite", ctx do
      assert %Right{right: user} = InviteRepo.signup(ctx.params, ctx.invite)
      assert user.email == ctx.invite.email
      # consumed_at should be set, meaning the invite should no longer be found.
      assert %Left{left: {status, _error}} = InviteRepo.get_invite(ctx.invite.id, user.email)
      assert status == :not_found
    end

    test "should fail to create a user given invalid args", ctx do
      assert %Left{left: {status, _error}} = InviteRepo.signup(%{}, ctx.invite)
      assert status == :invalid_args
    end
  end
end
