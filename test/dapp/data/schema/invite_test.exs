defmodule Dapp.Data.Schema.InviteTest do
  use ExUnit.Case, async: true

  alias Dapp.Data.Schema.Invite

  # Test context
  setup do
    %{email: TestUtil.fake_email(), role_id: 2}
  end

  # Test invite changeset validations
  describe "Invite.changeset" do
    test "succeeds on valid params", ctx do
      result = Invite.changeset(%Invite{}, ctx)
      assert result.valid?
    end

    test "fails on missing email param" do
      result = Invite.changeset(%Invite{}, %{role_id: 2})
      refute result.valid?
    end

    test "fails on missing role_id param" do
      result = Invite.changeset(%Invite{}, %{email: TestUtil.fake_email()})
      refute result.valid?
    end

    test "fails on empty params" do
      result = Invite.changeset(%Invite{}, %{})
      refute result.valid?
    end
  end
end
