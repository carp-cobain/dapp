defmodule Dapp.Plug.Router do
  @moduledoc """
    Handles business logic requests. 
  """
  use Plug.Router
  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.{Access, Auth}
  alias Dapp.UseCase.{GetResource, GetSecret}

  plug(:match)
  plug(Auth)
  plug(Access)
  plug(Plug.Parsers, parsers: [:urlencoded, {:multipart, length: 1_000_000}, :json], json_decoder: Jason)
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
