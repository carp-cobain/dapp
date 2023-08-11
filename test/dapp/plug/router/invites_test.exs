defmodule Dapp.Plug.Router.InvitesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  # alias Ecto.Adapters.SQL.Sandbox

  # Plug being tested
  alias Dapp.Plug.Router.Invites, as: InvitesPlug

  # Set up test context.
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    # :ok = Sandbox.checkout(Dapp.Repo)

    TestUtil.mock_audits()
    invite = TestUtil.mock_invite()
    user = TestUtil.mock_user("Admin")

    %{
      user: user,
      body: %{email: invite.email, role_id: invite.role_id}
    }
  end

  # Valid request
  test "Invites plug should allow admins to create invites.", ctx do
    res =
      conn(:post, "/", Jason.encode!(ctx.body))
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-address", ctx.user.blockchain_address)
      |> InvitesPlug.call([])

    assert res.status == 201
  end

  # Bad request
  test "Invites plug fails to create an invite with no body", ctx do
    res =
      conn(:post, "/")
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-address", ctx.user.blockchain_address)
      |> InvitesPlug.call([])

    assert res.status == 400
  end

  # Route not found
  test "Invites plug returns a 404 for unknown routes", ctx do
    opts = InvitesPlug.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.user.blockchain_address)
    res = InvitesPlug.call(req, opts)
    assert res.status == 404
  end
end
