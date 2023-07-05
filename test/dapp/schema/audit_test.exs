defmodule Dapp.Schema.AuditTest do
  use ExUnit.Case, async: true

  alias Dapp.Schema.Audit
  alias Dapp.UseCase.Signup

  # Test context
  setup do
    who = "tp#{Nanoid.generate(39)}" |> String.downcase()
    user = "user=#{Nanoid.generate()}"

    %{
      who: who,
      what: user,
      where: Signup.audit_name(),
      when: now()
    }
  end

  # Current timestamp
  defp now do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
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
