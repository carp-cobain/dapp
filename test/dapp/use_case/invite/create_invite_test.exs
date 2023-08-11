defmodule Dapp.UseCase.Invite.CreateInviteTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Algae.Reader

  import Hammox

  # Use case being tested
  alias Dapp.UseCase.Invite.CreateInvite

  # Pass mock data apis into use case.
  @opts [repo: InvitesMock, audit: AuditsMock]

  # Verify mocks on exit
  setup_all :verify_on_exit!

  # Create and return use case context
  setup do
    TestUtil.mock_audits()
    invite = TestUtil.mock_invite()

    %{
      args: %{
        email: invite.email,
        role_id: invite.role_id
      },
      expect: %{
        invite_code: invite.id
      }
    }
  end

  # CreateInvite use case tests
  describe "CreateInvite" do
    test "should create a new invite", ctx do
      assert %Right{right: dto} = CreateInvite.new(@opts) |> Reader.run(ctx)
      assert dto.invite.invite_code == ctx.expect.invite_code
    end

    test "should fail to create an invite with empty args" do
      ctx = %{args: %{}}
      assert %Left{left: {status, _error}} = CreateInvite.new(@opts) |> Reader.run(ctx)
      assert status == :invalid_args
    end
  end
end
