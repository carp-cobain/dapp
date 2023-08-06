defmodule Dapp.Plug.UsersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ecto.Adapters.SQL.Sandbox

  # Plug being tested
  alias Dapp.Plug.Users, as: UsersPlug

  # Set up sandbox and test context.
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    TestUtil.setup_user()
  end

  # Authorized request
  test "Users plug returns a user profile", ctx do
    opts = UsersPlug.init([])
    req = conn(:get, "/profile") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = UsersPlug.call(req, opts)
    assert res.status == 200
  end

  # Route not found
  test "Users plug returns a 404 for unknown routes", ctx do
    opts = UsersPlug.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = UsersPlug.call(req, opts)
    assert res.status == 404
  end
end
