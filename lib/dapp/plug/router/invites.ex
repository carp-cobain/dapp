defmodule Dapp.Plug.Router.Invites do
  @moduledoc """
  Maps invite endpoints to use cases.
  """
  use Dapp.Data.Repos
  use Plug.Router

  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Plug.Rbac.{Access, Auth, Header}
  alias Dapp.Plug.Req.InviteReq

  alias Dapp.UseCase.Invite.CreateInvite

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Admin"])
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow admins to create invites.
  post "/" do
    case InviteReq.validate(conn) do
      {:ok, args} -> create_invite(conn, args)
      {:error, error} -> Resp.send_json(conn, %{error: error}, 400)
    end
  end

  # Run use case
  defp create_invite(conn, args) do
    Handler.run(
      conn,
      CreateInvite.new(repo: invite_repo(), audit: audit_repo()),
      args
    )
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
