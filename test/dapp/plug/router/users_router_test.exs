defmodule Dapp.Plug.Router.UsersRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  # Plug being tested
  alias Dapp.Plug.Router.UsersRouter

  # Set up sandbox and test context.
  setup do
    TestUtil.mock_audits()
    %{user: TestUtil.mock_user()}
  end

  # Authorized request
  test "Users plug returns a user profile", ctx do
    opts = UsersRouter.init([])
    req = conn(:get, "/profile") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = UsersRouter.call(req, opts)
    assert res.status == 200
  end

  # Route not found
  test "Users plug returns a 404 for unknown routes", ctx do
    opts = UsersRouter.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = UsersRouter.call(req, opts)
    assert res.status == 404
  end
end
