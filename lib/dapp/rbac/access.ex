defmodule Dapp.Rbac.Access do
  @moduledoc """
  Controls access to protected routes.
  """
  alias Algae.Maybe.{Just, Nothing}
  alias Dapp.Data.Repo.UserRepo
  alias Dapp.Plug.Resp
  import Plug.Conn

  # When not provided explicitly, allow access to users with these roles.
  @default_roles ["Root", "User"]

  @doc "Handle white-listed roles."
  def init(opts) do
    if is_nil(opts[:roles]) do
      opts ++ [roles: @default_roles]
    else
      opts
    end
  end

  @doc "Check user access for a request."
  def call(conn, opts) do
    if Map.has_key?(conn.assigns, :user) do
      check_user_access(conn, opts)
    else
      Resp.forbidden(conn)
    end
  end

  # Assign role or halt request.
  defp check_user_access(conn, opts) do
    case UserRepo.get_role(conn.assigns.user.id) do
      %Nothing{} -> Resp.forbidden(conn)
      %Just{just: role} -> verify_role(conn, opts, role)
    end
  end

  # The user has a role in the DB, but we need to make sure the role was white-listed.
  defp verify_role(conn, opts, role) do
    if role in opts[:roles] do
      conn |> assign(:role, role)
    else
      Resp.forbidden(conn)
    end
  end

  # Allow a router to narrow the roles allowed to access a given route.
  def control(conn, roles, route) do
    if Map.get(conn.assigns, :role) in roles do
      route.()
    else
      Resp.forbidden(conn)
    end
  end

  @doc "Only allow the admin role to access a route."
  def root(conn, route) do
    control(conn, ["Root"], route)
  end
end
