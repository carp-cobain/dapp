defmodule Dapp.Rbac.Access do
  @moduledoc """
  Controls access to protected routes.
  """
  import Plug.Conn
  alias Dapp.Plug.Resp
  alias Dapp.Repo.UserRepo, as: Repo

  @admin_role "Admin"

  def init(opts), do: opts

  # Check user access.
  def call(conn, _opts) do
    if Map.has_key?(conn.assigns, :user) do
      check_user_access(conn)
    else
      Resp.unauthorized(conn)
    end
  end

  # Assign role or halt request.
  defp check_user_access(conn) do
    case Repo.access(conn.assigns.user) do
      :unauthorized -> Resp.unauthorized(conn)
      {:authorized, role} -> conn |> assign(:role, role)
    end
  end

  # Only allow admins to access a route.
  def admin(conn, route) do
    role = Map.get(conn.assigns, :role)

    if role == @admin_role do
      route.()
    else
      Resp.unauthorized(conn)
    end
  end
end
