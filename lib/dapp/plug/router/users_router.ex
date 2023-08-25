defmodule Dapp.Plug.Router.UsersRouter do
  @moduledoc """
  Maps user endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Plug.Controller.User.UserController
  alias Dapp.Plug.Rbac.{Auth, Header}
  alias Dapp.Plug.Resp

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(:dispatch)

  # Allow authorized users to see their profile.
  get "/profile" do
    UserController.get_profile(conn)
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
