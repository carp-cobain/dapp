defmodule Dapp.Repo.AccessRepoTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox

  alias Algae.Maybe.{Just, Nothing}
  alias Dapp.Repo
  alias Dapp.Repo.AccessRepo
  alias Dapp.Schema.User

  # Test context
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    addr = TestUtil.fake_address()
    user = Repo.insert!(%User{blockchain_address: addr})

    Map.merge(
      TestUtil.setup_user(),
      %{user_without_grant: user}
    )
  end

  # Test user repo
  describe "AccessRepo" do
    test "should authorize a user with a grant", ctx do
      assert AccessRepo.access(ctx.user.id) == %Just{just: ctx.role_name}
    end

    test "should NOT authorize a user without a grant", ctx do
      assert AccessRepo.access(ctx.user_without_grant.id) == %Nothing{}
    end

    test "should NOT authorize a non-existing user" do
      assert AccessRepo.access(Nanoid.generate()) == %Nothing{}
      assert AccessRepo.access(nil) == %Nothing{}
    end
  end
end
