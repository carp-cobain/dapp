defmodule Dapp.Rbac.Access do
  @moduledoc """
  Controls access to protected routes.
  """
  import Plug.Conn
  alias Dapp.Plug.Resp
  alias Dapp.Repo.UserRepo, as: Repo

  @default_roles ["Admin", "Viewer"]

  @doc "Set white-listed roles in opts if not provided."
  def init(opts) do
    if is_nil(opts[:roles]) do
      opts ++ [roles: @default_roles]
    else
      opts
    end
  end

  @doc "Check user access level for each request."
  def call(conn, opts) do
    if Map.has_key?(conn.assigns, :user) do
      check_user_access(conn, opts)
    else
      Resp.unauthorized(conn)
    end
  end

  # Assign role or halt request.
  defp check_user_access(conn, opts) do
    case Repo.access(conn.assigns.user.id) do
      :unauthorized -> Resp.unauthorized(conn)
      {:authorized, role} -> assign_role(conn, opts, role)
    end
  end

  # The user has a role in the DB, but we need to make sure the role was white-listed.
  defp assign_role(conn, opts, role) do
    if role in opts[:roles] do
      conn |> assign(:role, role)
    else
      Resp.unauthorized(conn)
    end
  end

  # Allow a router to narrow the roles allowed to access a given route.
  def control(conn, roles \\ [], route) do
    if Map.get(conn.assigns, :role) in roles do
      route.()
    else
      Resp.unauthorized(conn)
    end
  end

  @doc "Only allow the admin role to access a route."
  def admin(conn, route) do
    control(conn, ["Admin"], route)
  end
end
