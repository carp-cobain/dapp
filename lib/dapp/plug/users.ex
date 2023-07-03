defmodule Dapp.Plug.Users do
  @moduledoc """
  Maps user endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Audit
  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.Repo.UserRepo
  alias Dapp.UseCase.GetProfile

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Use case options
  @opts [repo: UserRepo, audit: Audit]

  # Allow all authorized users to see their profile.
  get "/profile" do
    get_profile(conn, %{user_id: conn.assigns.user.id})
  end

  # Allow admins to see anyone's profile.
  get "/:user_id/profile" do
    Access.admin(conn, fn ->
      get_profile(conn, %{user_id: user_id})
    end)
  end

  # Get profile helper.
  defp get_profile(conn, args) do
    Handler.run(
      conn,
      GetProfile.new(@opts),
      args
    )
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
