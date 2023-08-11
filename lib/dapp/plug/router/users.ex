defmodule Dapp.Plug.Router.Users do
  @moduledoc """
  Maps user endpoints to use cases.
  """
  use Dapp.Data.Repos
  use Plug.Router

  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Plug.Rbac.{Auth, Header}

  alias Dapp.UseCase.User.GetProfile

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(:dispatch)

  # Allow authorized users to see their profile.
  get "/profile" do
    Handler.run(
      conn,
      GetProfile.new(repo: user_repo(), audit: audit_repo()),
      %{user_id: conn.assigns.user.id}
    )
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
