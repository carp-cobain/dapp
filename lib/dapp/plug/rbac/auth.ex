defmodule Dapp.Plug.Rbac.Auth do
  @moduledoc """
  Authorizes requests with a blockchain address header.
  """
  import Plug.Conn

  alias Dapp.Data.Repo.UserRepo
  alias Dapp.Plug.Rbac.Header
  alias Dapp.Plug.Resp

  alias Algae.Either.{Left, Right}
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
    case Header.auth_header(conn) do
      {_, address} -> user_repo().get_user_by_address(address)
      _ -> Left.new(:bad_request)
    end
  end

  # Get configured user repo.
  defp user_repo do
    Application.get_env(:dapp, :user_repo, UserRepo)
  end
end
