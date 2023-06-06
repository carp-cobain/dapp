defmodule Dapp.Plug.UsersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Dapp.Repo
  alias Dapp.Repo.UserRepo
  alias Dapp.Schema.{Grant, Role}
  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Users, as: UsersPlug

  # Init state for the plug being tested
  @opts UsersPlug.init([])

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    setup_user("tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz")
  end

  # Make sure we insert a role + user w/ grant.
  defp setup_user(addr) do
    role = Repo.insert!(%Role{name: "Viewer"})
    user = UserRepo.create!(addr)
    Repo.insert!(%Grant{user: user, role: role})
    %{address: addr, user: user}
  end

  # Authorized request
  test "it returns a user profile for viewer", ctx do
    req = conn(:get, "/profile") |> put_req_header("x-address", ctx.address)
    res = UsersPlug.call(req, @opts)
    assert res.status == 200
  end

  # Unauthorized request
  test "it returns a 401 for viewer calling an admin route", ctx do
    fake_id = Nanoid.generate()
    req = conn(:get, "/#{fake_id}/profile") |> put_req_header("x-address", ctx.address)
    res = UsersPlug.call(req, @opts)
    assert res.status == 401
  end
end
