defmodule Dapp.Plug.Users do
  @moduledoc """
  Maps user endpoints to use cases.
  """
  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.{Access, Auth}
  alias Dapp.Repo.UserRepo
  alias Dapp.UseCase.GetProfile
  use Plug.Router

  plug(:match)
  plug(Auth)
  plug(Access)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow all authorized users to see their profile.
  get "/profile" do
    Handler.run(
      conn,
      GetProfile.new(UserRepo),
      %{user_id: conn.assigns.user.id}
    )
  end

  # Allow admins to see anyone's profile.
  get "/:user_id/profile" do
    Access.admin(conn, fn ->
      Handler.run(
        conn,
        GetProfile.new(UserRepo),
        %{user_id: user_id}
      )
    end)
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
