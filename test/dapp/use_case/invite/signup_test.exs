defmodule Dapp.UseCase.Invite.SignupTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Algae.Reader

  import Hammox

  # Use case being tested
  alias Dapp.UseCase.Invite.Signup

  # Pass mock data apis into use case.
  @opts [repo: InvitesMock, audit: AuditsMock]

  # Verify mocks on exit
  setup_all :verify_on_exit!

  # Create and return use case context
  setup do
    TestUtil.mock_audits()
    addr = TestUtil.fake_address()
    invite = TestUtil.mock_invite()

    %{
      args: %{
        blockchain_address: addr,
        name: "Jane Doe",
        email: invite.email,
        invite_code: invite.id
      },
      expect: %{
        blockchain_address: addr
      }
    }
  end

  # Signup use case tests
  describe "Signup" do
    # Signup success
    test "should create a user profile", ctx do
      assert %Right{right: dto} = Signup.new(@opts) |> Reader.run(ctx)
      assert dto.blockchain_address == ctx.expect.blockchain_address
    end

    # Invite not found
    test "should fail to create user profile when invite is not found" do
      ctx = %{args: %{invite_code: Nanoid.generate(), email: TestUtil.fake_email()}}
      assert %Left{left: {status, _error}} = Signup.new(@opts) |> Reader.run(ctx)
      assert status == :not_found
    end

    # Signup failure
    test "should fail to create user profile with empty args" do
      ctx = %{args: %{}}
      assert %Left{left: {status, _error}} = Signup.new(@opts) |> Reader.run(ctx)
      assert status == :invalid_args
    end
  end
end
