defmodule Dapp.Repo.UserRepoTest do
  use ExUnit.Case, async: true
  alias Dapp.Repo.UserRepo, as: Repo
  alias Nanoid.Configuration, as: NanoidConfig

  # Test context
  setup do
    %{address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz"}
  end

  # Test user repo
  describe "UserRepo" do
    test "should create and get a user using a blockchain address", ctx do
      user = Repo.create!(ctx.address)
      assert String.length(user.id) == NanoidConfig.default_size()
      assert Repo.get(ctx.address) == user
    end
  end
end
