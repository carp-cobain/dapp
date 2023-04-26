defmodule Dapp.Plug.Router do
  @moduledoc """
  Core HTTP router.
  """
  use Plug.Router
  alias Dapp.Plug.{Features, Handler, Resp}
  alias Dapp.Rbac.{Access, Auth}
  alias Dapp.UseCase.{GetMe, GetResource, GetSecret, GetUsers}

  plug(:match)
  plug(Auth)
  plug(Access)
  plug(Features)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow authorized users to view.
  get "/resource" do
    Handler.execute(conn, GetResource)
  end

  # Allow authorized users to see their own info.
  get "/me" do
    Handler.execute(conn, GetMe)
  end

  # Only allow admins to the secret
  get "/secret" do
    Access.admin(conn, fn ->
      Handler.execute(conn, GetSecret)
    end)
  end

  # Only allow admins to see all users.
  get "/users" do
    Access.admin(conn, fn ->
      Handler.execute(conn, GetUsers)
    end)
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
