defmodule Dapp.Plug do
  @moduledoc """
  Map top-level routes to internal routers.
  """
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  alias Dapp.Plug.Resp
  alias Dapp.Plug.Router.{Invites, Roles, Signup, Users}

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  forward("/dapp/v1/invites", to: Invites)
  forward("/dapp/v1/roles", to: Roles)
  forward("/dapp/v1/signup", to: Signup)
  forward("/dapp/v1/users", to: Users)

  # Health checks.
  get "/health/*glob" do
    Resp.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
