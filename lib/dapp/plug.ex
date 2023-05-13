defmodule Dapp.Plug do
  @moduledoc """
  Top-level plug: handles status requests and forwards to internal router.
  """

  alias Dapp.Plug.Resp

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Forward to plug router.
  forward("/dapp/v1", to: Dapp.Plug.Router)
  forward("/dapp/api/v1", to: Dapp.Plug.Router)

  # Status route.
  get "/dapp/status" do
    Resp.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
