defmodule Dapp.Plug.RolesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ecto.Adapters.SQL.Sandbox

  # Plug being tested
  alias Dapp.Plug.Roles, as: RolesPlug

  # Set up sandbox and test context.
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    TestUtil.setup_user("Root")
  end

  # Authorized admin request for roles
  test "Roles plug returns a all roles for an admin", ctx do
    opts = RolesPlug.init([])
    req = conn(:get, "/") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = RolesPlug.call(req, opts)
    assert res.status == 200
  end

  test "Roles plug returns a 4xx for an non-admin" do
    ctx = TestUtil.mock_user()
    opts = RolesPlug.init([])
    req = conn(:get, "/") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = RolesPlug.call(req, opts)
    assert res.status == 401
  end

  test "Roles plug returns a 404 for an unknown route", ctx do
    opts = RolesPlug.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = RolesPlug.call(req, opts)
    assert res.status == 404
  end
end
