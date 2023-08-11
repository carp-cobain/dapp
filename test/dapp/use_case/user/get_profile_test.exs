defmodule Dapp.UseCase.User.GetProfileTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Algae.Reader

  import Hammox

  # Use case being tested
  alias Dapp.UseCase.User.GetProfile

  # Pass mock data apis into use case.
  @opts [repo: UsersMock, audit: AuditsMock]

  # Verify mocks on exit
  setup_all :verify_on_exit!

  # Create user and return use case context
  setup do
    TestUtil.mock_audits()
    user = TestUtil.mock_user()

    %{
      args: %{user_id: user.id},
      expect: %{blockchain_address: user.blockchain_address}
    }
  end

  # GetProfile use case tests
  describe "GetProfile" do
    test "should return an existing user profile", ctx do
      assert %Right{right: dto} = GetProfile.new(@opts) |> Reader.run(ctx)
      assert dto.profile.blockchain_address == ctx.expect.blockchain_address
    end

    test "should return an error when a user is not found" do
      ctx = %{args: %{user_id: Nanoid.generate()}}
      assert %Left{left: {status, _error}} = GetProfile.new(@opts) |> Reader.run(ctx)
      assert status == :not_found
    end
  end
end
