defmodule Dapp.Plug.SignupTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Dapp.Repo
  alias Dapp.Schema.{Invite, Role}
  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Signup, as: SignupPlug

  # Required role granted upon signup.
  @signup_role Application.compile_env(:dapp, :signup_role)

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)

    # Insert invite
    code = Nanoid.generate()
    email = "user-#{Nanoid.generate(6)}@domain.com"
    role = setup_role()
    Repo.insert!(%Invite{id: code, email: email, role_id: role.id})

    # Test context
    %{
      body: %{
        name: "User #{Nanoid.generate(6)}",
        email: email,
        code: code
      },
      header: "tp#{Nanoid.generate(39)}" |> String.downcase()
    }
  end

  # Get or insert a role
  defp setup_role do
    case Repo.get_by(Role, name: @signup_role) do
      nil -> Repo.insert!(%Role{name: @signup_role})
      role -> role
    end
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

    assert res.status == 400
  end
end
