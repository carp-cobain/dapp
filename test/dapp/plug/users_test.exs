defmodule Dapp.Plug.UsersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Users, as: UsersPlug

  # Set up sandbox and test context.
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    TestUtil.setup_user()
  end

  # Authorized request
  test "Users plug returns a user profile for viewer", ctx do
    opts = UsersPlug.init([])
    req = conn(:get, "/profile") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = UsersPlug.call(req, opts)
    assert res.status == 200
  end

  # Unauthorized request
  test "Users plug returns bad request for viewer calling an admin route", ctx do
    opts = UsersPlug.init([])
    fake_id = Nanoid.generate()
    req = conn(:get, "/#{fake_id}/profile") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = UsersPlug.call(req, opts)
    assert res.status == 400
  end

  # Route not found
  test "Users plug returns a 404 for unknown routes", ctx do
    opts = UsersPlug.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = UsersPlug.call(req, opts)
    assert res.status == 404
  end
end
