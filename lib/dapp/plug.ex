defmodule Dapp.Plug do
  @moduledoc """
  Top-level plug: handles status requests and forwards to internal router.
  """
  use Plug.Router
  alias Dapp.Plug.Resp

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Forward to plug router.
  forward("/dapp/secure/api/v1", to: Dapp.Plug.Router)

  # Status route.
  get "/status" do
    send_resp(conn, 200, "up")
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
