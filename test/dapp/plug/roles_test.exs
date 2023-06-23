defmodule Dapp.Plug.RolesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Dapp.Repo
  alias Dapp.Schema.{Grant, Role, User}
  alias Ecto.Adapters.SQL.Sandbox

  alias Dapp.Plug.Roles, as: RolesPlug

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    ensure_role("Admin")
    "tp#{Nanoid.generate(39)}" |> String.downcase() |> setup_user()
  end

  # Make sure we insert a role + user w/ grant.
  defp setup_user(addr) do
    user = Repo.insert!(%User{blockchain_address: addr})
    role = Repo.get_by(Role, name: "Admin")
    Repo.insert!(%Grant{user: user, role: role})
    %{address: addr}
  end

  # Make sure a role exists in the DB.
  defp ensure_role(name) do
    if is_nil(Repo.get_by(Role, name: name)) do
      Repo.insert!(%Role{name: name})
    end
  end

  # Authorized admin request for roles
  test "it returns a all roles for an admin", ctx do
    opts = RolesPlug.init([])
    req = conn(:get, "/") |> put_req_header("x-address", ctx.address)
    res = RolesPlug.call(req, opts)
    assert res.status == 200
  end

  test "it returns a bad request for an non-admin" do
    opts = RolesPlug.init([])
    address = "tp#{Nanoid.generate(39)}" |> String.downcase()
    req = conn(:get, "/") |> put_req_header("x-address", address)
    res = RolesPlug.call(req, opts)
    assert res.status == 400
  end

  test "it returns a 404 for an unknown route", ctx do
    opts = RolesPlug.init([])
    req = conn(:get, "/nonesuch") |> put_req_header("x-address", ctx.address)
    res = RolesPlug.call(req, opts)
    assert res.status == 404
  end
end
