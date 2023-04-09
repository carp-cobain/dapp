defmodule Dapp.Plug.Router do
  @moduledoc """
    Handles business logic requests. 
  """
  use Plug.Router
  alias Dapp.Plug.Handler
  alias Dapp.Rbac.Access
  alias Dapp.Rbac.Auth
  alias Dapp.UseCase.GetResource
  alias Dapp.UseCase.GetSecret

  plug(:match)
  plug(Auth)
  plug(Access)
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
    Handler.not_found(conn)
  end
end
