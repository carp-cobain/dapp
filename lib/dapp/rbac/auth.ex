defmodule Dapp.Rbac.Auth do
  @moduledoc """
  Authorizes requests with a blockchain address header.
  """
  import Plug.Conn

  alias Dapp.Plug.Resp
  alias Dapp.Rbac.Header
  alias Dapp.Repo.UserRepo

  alias Algae.Either.Right
  use Witchcraft

  @doc false
  def init(opts), do: opts

  @doc "Authorize users with valid blockchain address headers."
  def call(conn, _opts) do
    case auth_user(conn) do
      %Right{right: user} -> assign(conn, :user, user)
      _ -> Resp.unauthorized(conn)
    end
  end

  # Get an authorized user from the db using a request header.
  defp auth_user(conn) do
    Header.auth_header(conn)
    |> UserRepo.get_by_address()
  end
end
