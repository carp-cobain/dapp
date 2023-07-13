defmodule Dapp.Plug.RolesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Roles, as: RolesPlug

  # Set up sandbox and test context.
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    TestUtil.setup_user("Admin")
  end

  # Authorized admin request for roles
  test "Roles plug returns a all roles for an admin", ctx do
    opts = RolesPlug.init([])
    req = conn(:get, "/") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = RolesPlug.call(req, opts)
    assert res.status == 200
  end

  test "Roles plug returns a bad request for an non-admin" do
    opts = RolesPlug.init([])
    address = "tp#{Nanoid.generate(39)}" |> String.downcase()
    req = conn(:get, "/") |> put_req_header("x-address", address)
    res = RolesPlug.call(req, opts)
    assert res.status == 400
  end

  test "Roles plug returns a 404 for an unknown route", ctx do
    opts = RolesPlug.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = RolesPlug.call(req, opts)
    assert res.status == 404
  end
end
