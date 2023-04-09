defmodule Dapp.Rbac.Access do
  @moduledoc """
    Controls access to protected routes.
  """
  import Plug.Conn
  alias Dapp.Data.Query
  alias Dapp.Plug.Handler

  @admin_role "Admin"

  def init(opts), do: opts

  # Check user access.
  def call(conn, _opts) do
    if Map.has_key?(conn.assigns, :user) do
      check_user_access(conn)
    else
      Handler.unauthorized(conn)
    end
  end

  # Assign role or halt request.
  defp check_user_access(conn) do
    role = Query.get_user_role(conn.assigns.user)

    if is_nil(role) do
      Handler.unauthorized(conn)
    else
      conn |> assign(:role, role)
    end
  end

  # Only allow admins to access a route.
  def admin(conn, route) do
    role = Map.get(conn.assigns, :role)

    if role == @admin_role do
      route.()
    else
      Handler.unauthorized(conn)
    end
  end
end
