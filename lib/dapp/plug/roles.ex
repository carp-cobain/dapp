defmodule Dapp.Plug.Roles do
  @moduledoc """
  Maps role endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.Repo.RoleRepo
  alias Dapp.UseCase.GetRoles

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Admin"])
  plug(:dispatch)

  # Use case options
  @opts [repo: RoleRepo]

  # Allow admins to see available roles.
  get "/" do
    Handler.run(conn, GetRoles.new(@opts))
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
