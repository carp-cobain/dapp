defmodule Dapp.Plug.Router do
  @moduledoc """
  Forward requests to internal routers.
  """
  use Plug.Router

  alias Dapp.Plug.Resp
  alias Dapp.Plug.Router.{InvitesRouter, RolesRouter, SignupRouter, UsersRouter}

  plug(:match)
  plug(:dispatch)

  forward("/invites", to: InvitesRouter)
  forward("/roles", to: RolesRouter)
  forward("/signup", to: SignupRouter)
  forward("/users", to: UsersRouter)

  # Respond with 404.
  match _ do
    Resp.not_found(conn)
  end
end
