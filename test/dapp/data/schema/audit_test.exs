defmodule Dapp.Data.Schema.AuditTest do
  use ExUnit.Case, async: true

  alias Dapp.Data.Schema.Audit

  # Test context
  setup do
    %{
      who: TestUtil.fake_address(),
      what: "user=#{Nanoid.generate()}",
      where: "AuditTest",
      when: DateTime.utc_now() |> DateTime.truncate(:second)
    }
  end

  # Test audit changeset validations
  describe "Audit.changeset" do
    test "succeeds on valid params", ctx do
      result = Audit.changeset(%Audit{}, ctx)
      assert result.valid?
    end

    test "fails on invalid params" do
      result = Audit.changeset(%Audit{}, %{})
      refute result.valid?
    end
  end
end
