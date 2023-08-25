defmodule Dapp.Plug do
  @moduledoc """
  Map versioned routes to internal routers.
  """
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  alias Dapp.Plug.Resp
  alias Dapp.Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Forward v1 requests to internal router.
  forward("/dapp/v1", to: Router)

  # Health checks.
  get "/health/*glob" do
    Resp.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
