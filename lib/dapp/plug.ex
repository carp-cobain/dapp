defmodule Dapp.Plug do
  @moduledoc """
    Top-level plug: handles status requests and forwards to core router for
    all other known request handling.
  """
  use Plug.Router
  alias Dapp.Plug.Handler

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Forward to plug router.
  forward("/dapp/v1/protected", to: Dapp.Plug.Router)

  # Status route.
  get "/status" do
    send_resp(conn, 200, "up")
  end

  # Respond with 404.
  match _ do
    conn |> Handler.not_found()
  end
end
