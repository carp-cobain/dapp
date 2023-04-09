defmodule Dapp.Rbac.Auth do
  @moduledoc """
    Authorizes requests with a blockchain address header.
  """
  import Plug.Conn
  alias Dapp.Data.Query
  alias Dapp.Plug.Handler
  alias Dapp.Rbac.Header

  def init(opts), do: opts

  # Authorize users with valid blockchain address headers.
  def call(conn, _opts) do
    conn
    |> Header.auth_header()
    |> authorize(conn)
  end

  # Authorize user unless we got a nil address.
  defp authorize(addr, conn) do
    if is_nil(addr) do
      Handler.unauthorized(conn)
    else
      get_user(conn, addr)
    end
  end

  # Pull user from the repo and assign it for use in subsequent plugs.
  defp get_user(conn, addr) do
    case Query.get_user(addr) do
      nil -> Handler.unauthorized(conn)
      user -> conn |> assign(:user, user)
    end
  end
end
