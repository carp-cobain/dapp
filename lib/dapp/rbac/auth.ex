defmodule Dapp.Rbac.Auth do
  @moduledoc """
  Authorizes requests with a blockchain address header.
  """
  alias Dapp.Plug.Resp
  alias Dapp.Rbac.Header
  alias Dapp.Repo.UserRepo
  import Plug.Conn

  alias Algae.Maybe
  alias Algae.Maybe.{Just, Nothing}
  use Witchcraft

  @doc false
  def init(opts), do: opts

  @doc "Authorize users with valid blockchain address headers."
  def call(conn, _opts) do
    case auth_user(conn) do
      %Just{just: user} -> assign(conn, :user, user)
      %Nothing{} -> Resp.unauthorized(conn)
    end
  end

  # Get an authorized user from the db using a request header.
  defp auth_user(conn) do
    Header.auth_header(conn) >>>
      fn addr ->
        UserRepo.get_by_address(addr)
        |> Maybe.from_nillable()
      end
  end
end
