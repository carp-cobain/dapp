defmodule Dapp.Plug do
  @moduledoc """
  Handles status requests and forwards to internal routers.
  """
  alias Dapp.Plug.Resp
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Forward to users router.
  forward("/dapp/v1/users", to: Dapp.Plug.Users)

  # Status route.
  get "/dapp/status" do
    Resp.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
