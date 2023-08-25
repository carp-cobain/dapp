defmodule Dapp.Plug.Router.SignupRouter do
  @moduledoc """
  Maps signup endpoints to use case.
  """
  use Plug.Router

  alias Dapp.Plug.Controller.Signup.SignupController
  alias Dapp.Plug.Rbac.Header
  alias Dapp.Plug.Resp

  plug(:match)
  plug(Header)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow invited users to sign up.
  post "/" do
    SignupController.signup(conn)
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
