defmodule Dapp.Plug.Router do
  @moduledoc """
  Core HTTP router.
  """
  use Plug.Router
  alias Dapp.Plug.{Features, Handler, Resp}
  alias Dapp.Rbac.{Access, Auth}
  alias Dapp.UseCase.{GetResource, GetSecret}

  plug(:match)
  plug(Auth)
  plug(Access)
  plug(Features)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Only allow authorized users.
  get "/resource" do
    Handler.execute(conn, GetResource)
  end

  # Only allow authorized admins.
  get "/secret" do
    Access.admin(conn, fn ->
      Handler.execute(conn, GetSecret)
    end)
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
