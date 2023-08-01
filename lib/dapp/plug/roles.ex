defmodule Dapp.Plug.Roles do
  @moduledoc """
  Maps role endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.Repo.RoleRepo
  alias Dapp.UseCase.Role.GetRoles

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Root"])
  plug(:dispatch)

  # Use case options

  # Allow admins to see available roles.
  get "/" do
    Handler.run(conn, GetRoles.new(repo: RoleRepo))
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
