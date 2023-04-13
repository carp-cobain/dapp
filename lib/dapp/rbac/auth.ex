defmodule Dapp.Rbac.Auth do
  @moduledoc """
    Authorizes requests with a blockchain address header.
  """
  import Plug.Conn
  alias Dapp.Data.Repo.UserRepo, as: Repo
  alias Dapp.Plug.Resp
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
      Resp.unauthorized(conn)
    else
      assign_user(conn, addr)
    end
  end

  # Pull user from the repo and assign it for use in subsequent plugs.
  defp assign_user(conn, addr) do
    case Repo.get(addr) do
      nil -> Resp.unauthorized(conn)
      user -> conn |> assign(:user, user)
    end
  end
end
