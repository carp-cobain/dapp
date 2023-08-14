defmodule Dapp.Data.Repo.AuditRepoTest do
  use ExUnit.Case, async: true
  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Data.Schema.Audit
  alias Dapp.Repo

  # Repo being tested
  alias Dapp.Data.Repo.AuditRepo

  # Set up SQL sandbox.
  setup do
    Sandbox.checkout(Dapp.Repo)
    # Reset audit flag after each test
    on_exit(fn -> Application.put_env(:dapp, :audit_disabled, false) end)
    %{blockchain_address: TestUtil.fake_address()}
  end

  # Test that repo can insert audits into the db.
  describe "AuditRepo" do
    test "should insert an audit record", ctx do
      assert :ok = AuditRepo.log(ctx, "AuditRepoTest", "test")
      assert audits = Repo.all(Audit)
      assert length(audits) == 1
    end

    test "should do nothing when disabled", ctx do
      Application.put_env(:dapp, :audit_disabled, true)
      assert :ok = AuditRepo.log(ctx, "AuditRepoTest", "test")
      assert Repo.all(Audit) == []
    end
  end
end
