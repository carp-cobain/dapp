defmodule Dapp.Rbac.Auth do
  @moduledoc """
  Authorizes requests with a blockchain address header.
  """
  import Plug.Conn
  alias Dapp.Plug.Resp
  alias Dapp.Rbac.Header
  alias Dapp.Repo.UserRepo, as: Repo

  def init(opts), do: opts

  # Authorize users with valid blockchain address headers.
  def call(conn, _opts) do
    addr = conn |> Header.auth_header()
    conn |> authorize(addr)
  end

  # Authorize user if an address was found.
  defp authorize(conn, addr) do
    if is_nil(addr) do
      conn |> Resp.unauthorized()
    else
      conn |> assign_user(addr)
    end
  end

  # Pull user from the repo and assign it for use in subsequent plugs.
  defp assign_user(conn, addr) do
    case Repo.get(addr) do
      nil -> conn |> Resp.unauthorized()
      user -> conn |> assign(:user, user)
    end
  end
end
