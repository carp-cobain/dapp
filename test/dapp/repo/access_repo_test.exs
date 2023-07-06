defmodule Dapp.Repo.AccessRepoTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Repo
  alias Dapp.Repo.AccessRepo
  alias Dapp.Schema.{Grant, Role, User}

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    addr = "tp#{Nanoid.generate(39)}" |> String.downcase()
    user = Repo.insert!(%User{blockchain_address: addr})
    role = ensure_role()
    Repo.insert!(%Grant{user: user, role: role})
    %{user_id: user.id, role: role.name}
  end

  # Ensure a test role is written to the db
  defp ensure_role do
    case Repo.get_by(Role, name: "Viewer") do
      nil -> Repo.insert!(%Role{name: "Viewer"})
      role -> role
    end
  end

  # Test user repo
  describe "AccessRepo" do
    test "should authorize a user with a grant", ctx do
      assert AccessRepo.access(ctx.user_id) == {:authorized, ctx.role}
    end

    test "should NOT authorize an existing user without a grant" do
      addr = "tp#{Nanoid.generate(39)}" |> String.downcase()
      user = Repo.insert!(%User{blockchain_address: addr})
      assert AccessRepo.access(user.id) == :unauthorized
    end

    test "should NOT authorize a non-existing user" do
      assert AccessRepo.access(Nanoid.generate()) == :unauthorized
    end

    test "should NOT authorize a nil user_id" do
      assert AccessRepo.access(nil) == :unauthorized
    end
  end
end
