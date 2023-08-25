defmodule Dapp.Plug.Router.RolesRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Hammox

  # Plug being tested
  alias Dapp.Plug.Router.RolesRouter

  # Set up sandbox and test context.
  setup do
    RolesMock |> expect(:get_roles, &TestUtil.fake_roles/0)
    %{user: TestUtil.mock_user("Admin")}
  end

  # Authorized admin request for roles
  test "Roles plug returns a all roles for an admin", ctx do
    opts = RolesRouter.init([])
    req = conn(:get, "/") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = RolesRouter.call(req, opts)
    assert res.status == 200
  end

  test "Roles plug returns a 4xx for an non-admin" do
    user = TestUtil.mock_user()
    opts = RolesRouter.init([])
    req = conn(:get, "/") |> put_req_header("x-address", user.blockchain_address)
    res = RolesRouter.call(req, opts)
    assert res.status == 401
  end

  test "Roles plug returns a 404 for an unknown route", ctx do
    opts = RolesRouter.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = RolesRouter.call(req, opts)
    assert res.status == 404
  end
end
