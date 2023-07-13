defmodule Dapp.Plug.SignupTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Signup, as: SignupPlug

  # Set up sandbox and test context.
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)

    # Insert invite
    invite = TestUtil.setup_invite()

    # Test context
    %{
      header: TestUtil.fake_address(),
      body: %{
        name: "User #{Nanoid.generate(6)}",
        code: invite.id,
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
      |> SignupPlug.call([])

    assert res.status == 201
  end

  # Failed signup: no name, email, or invite code.
  test "Signup plug fails to create a profile with no body", ctx do
    res =
      conn(:post, "/")
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-address", ctx.header)
      |> SignupPlug.call([])

    assert res.status == 400
  end

  # Failed signup: no auth header.
  test "Signup plug fails to create a profile with no auth header", ctx do
    res =
      conn(:post, "/", Jason.encode!(ctx.body))
      |> put_req_header("content-type", "application/json")
      |> SignupPlug.call([])

    assert res.status == 400
  end
end
