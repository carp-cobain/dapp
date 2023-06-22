defmodule Dapp.Plug.SignupTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Dapp.Repo
  alias Dapp.Schema.Role
  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Signup, as: SignupPlug

  # Required role granted upon signup.
  @signup_role Application.compile_env(:dapp, :signup_role)

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)

    # Insert role if not found
    if is_nil(Repo.get_by(Role, name: @signup_role)) do
      Repo.insert!(%Role{name: @signup_role})
    end

    # Test context
    %{
      body: %{
        name: "User #{Nanoid.generate(6)}",
        email: "user-#{Nanoid.generate(6)}@domain.com"
      },
      header: "tp#{Nanoid.generate(39)}" |> String.downcase()
    }
  end

  # Successful signup
  test "it creates a profile", ctx do
    res =
      conn(:post, "/", Jason.encode!(ctx.body))
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-address", ctx.header)
      |> SignupPlug.call([])

    assert res.status == 201
  end

  # Failed signup: no name or email.
  test "it fails to create a profile with no body", ctx do
    res =
      conn(:post, "/")
      |> put_req_header("content-type", "application/json")
      |> put_req_header("x-address", ctx.header)
      |> SignupPlug.call([])

    assert res.status == 400
  end

  # Failed signup: no auth header.
  test "it fails to create a profile with no auth header", ctx do
    res =
      conn(:post, "/", Jason.encode!(ctx.body))
      |> put_req_header("content-type", "application/json")
      |> SignupPlug.call([])

    assert res.status == 401
  end
end
