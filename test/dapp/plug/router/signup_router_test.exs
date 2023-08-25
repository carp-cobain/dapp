defmodule Dapp.Plug.Router.SignupRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  # Plug being tested
  alias Dapp.Plug.Router.SignupRouter

  # Set up sandbox and test context.
  setup do
    TestUtil.mock_audits()
    invite = TestUtil.mock_invite()

    # Test context
    %{
      header: TestUtil.fake_address(),
      body: %{
        name: "Jane Doe",
        invite_code: invite.id,
        email: invite.email
      }
    }
  end

  # Successful signup
  test "Signup plug creates a profile", ctx do
    res =
      conn(:post, "/", Jason.encode!(ctx.body))
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-address", ctx.header)
      |> SignupRouter.call([])

    assert res.status == 201
  end

  # Failed signup: no name, email, or invite code.
  test "Signup plug fails to create a profile with no body", ctx do
    res =
      conn(:post, "/")
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-address", ctx.header)
      |> SignupRouter.call([])

    assert res.status == 400
  end

  # Failed signup: no auth header.
  test "Signup plug fails to create a profile with no auth header", ctx do
    res =
      conn(:post, "/", Jason.encode!(ctx.body))
      |> put_req_header("content-type", "application/json")
      |> SignupRouter.call([])

    assert res.status == 400
  end
end
