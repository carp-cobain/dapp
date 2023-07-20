defmodule Dapp.Plug do
  @moduledoc """
  Map top-level routes to internal routers.
  """
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  alias Dapp.Plug.Resp

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Forward to roles router.
  forward("/dapp/v1/roles", to: Dapp.Plug.Roles)

  # Forward to signup router.
  forward("/dapp/v1/signup", to: Dapp.Plug.Signup)

  # Forward to users router.
  forward("/dapp/v1/users", to: Dapp.Plug.Users)

  # Health checks.
  get "/health/*glob" do
    Resp.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
