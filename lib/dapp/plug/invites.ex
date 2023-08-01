defmodule Dapp.Plug.Invites do
  @moduledoc """
  Maps invite endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Audit
  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.Repo.InviteRepo
  alias Dapp.UseCase.Invite.CreateInvite

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Root"])
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow admins to create user invites.
  post "/" do
    Handler.run(
      conn,
      CreateInvite.new(repo: InviteRepo, audit: Audit),
      args(conn)
    )
  end

  # Collect use case args.
  defp args(conn),
    do: %{
      email: conn.body_params["email"],
      role_id: conn.body_params["role_id"]
    }

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
