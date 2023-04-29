defmodule Dapp.Repo.UserRepoTest do
  use ExUnit.Case, async: true

  alias Dapp.Repo.UserRepo
  alias Ecto.Adapters.SQL.Sandbox
  alias Nanoid.Configuration, as: NanoidConfig

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    :ok = Sandbox.checkout(Dapp.Repo)
    %{address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz"}
  end

  # Test user repo
  describe "UserRepo" do
    test "should create and get a user using a blockchain address", ctx do
      user = UserRepo.create!(ctx.address)
      assert String.length(user.id) == NanoidConfig.default_size()
      assert UserRepo.get(ctx.address) == user
    end
  end
end
