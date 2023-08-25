defmodule Dapp.Plug.Router.RolesRouter do
  @moduledoc """
  Maps role endpoints to use cases.
  """
  use Dapp.Data.Repos
  use Plug.Router

  alias Dapp.Plug.Controller
  alias Dapp.Plug.Rbac.{Access, Auth, Header}
  alias Dapp.Plug.Resp

  alias Dapp.UseCase.Role.GetRoles

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Admin"])
  plug(:dispatch)

  # Allow admins to see available roles.
  get "/" do
    Controller.run(conn, GetRoles.new(repo: role_repo()))
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
