defmodule Dapp.Plug.Router do
  @moduledoc """
  Maps HTTP requests to use cases.
  """
  alias Dapp.Plug.{Features, Handler, Resp}
  alias Dapp.Rbac.{Access, Auth}
  alias Dapp.UseCase.{GetProfile, GetUsers}
  use Plug.Router

  plug(:match)
  plug(Auth)
  plug(Access)
  plug(Features)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow all authorized users to see their profile.
  get "/profile" do
    Handler.execute(conn, GetProfile)
  end

  # Only allow admins to see all users.
  get "/users" do
    Access.admin(conn, fn ->
      Handler.execute(conn, GetUsers)
    end)
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
