defmodule Dapp.Plug.UsersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Dapp.Repo
  alias Dapp.Schema.{Grant, Role, User}
  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Users, as: UsersPlug

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    "tp#{Nanoid.generate(39)}" |> String.downcase() |> setup_user()
  end

  # Make sure we insert a role + user w/ grant.
  defp setup_user(addr) do
    user = Repo.insert!(%User{blockchain_address: addr})
    Repo.insert!(%Grant{user: user, role: setup_role()})
    %{address: addr}
  end

  # Get or insert a role
  defp setup_role do
    case Repo.get_by(Role, name: "Viewer") do
      nil -> Repo.insert!(%Role{name: "Viewer"})
      role -> role
    end
  end

  # Authorized request
  test "it returns a user profile for viewer", ctx do
    opts = UsersPlug.init([])
    req = conn(:get, "/profile") |> put_req_header("x-address", ctx.address)
    res = UsersPlug.call(req, opts)
    assert res.status == 200
  end

  # Unauthorized request
  test "it returns a 401 for viewer calling an admin route", ctx do
    opts = UsersPlug.init([])
    fake_id = Nanoid.generate()
    req = conn(:get, "/#{fake_id}/profile") |> put_req_header("x-address", ctx.address)
    res = UsersPlug.call(req, opts)
    assert res.status == 401
  end

  # Route not found
  test "it returns a 404 for unknown routes", ctx do
    opts = UsersPlug.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.address)
    res = UsersPlug.call(req, opts)
    assert res.status == 404
  end
end
