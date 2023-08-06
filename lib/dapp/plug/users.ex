defmodule Dapp.Plug.Users do
  @moduledoc """
  Maps user endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Data.Repo.{AuditRepo, UserRepo}
  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.UseCase.User.GetProfile

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow authorized users to see their profile.
  get "/profile" do
    Handler.run(
      conn,
      GetProfile.new(repo: UserRepo, audit: AuditRepo),
      %{user_id: conn.assigns.user.id}
    )
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
