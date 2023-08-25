defmodule Dapp.Plug.Router.InvitesRouter do
  @moduledoc """
  Maps invite endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Plug.Controller.Invite.InviteController
  alias Dapp.Plug.Rbac.{Access, Auth, Header}
  alias Dapp.Plug.Resp

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Admin"])
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow admins to create invites.
  post "/" do
    InviteController.create_invite(conn)
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
