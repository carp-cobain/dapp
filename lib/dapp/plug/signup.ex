defmodule Dapp.Plug.Signup do
  @moduledoc """
  Maps signup endpoint to use case.
  """
  use Plug.Router

  alias Dapp.Audit
  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.Header
  alias Dapp.Repo.InviteRepo
  alias Dapp.UseCase.Invite.Signup

  plug(:match)
  plug(Header)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Create a new user from an invite.
  post "/" do
    Handler.run(
      conn,
      Signup.new(repo: InviteRepo, audit: Audit),
      signup_args(conn)
    )
  end

  # Get args from request.
  defp signup_args(conn),
    do: %{
      blockchain_address: conn.assigns.blockchain_address,
      name: conn.body_params["name"],
      email: conn.body_params["email"],
      invite_code: conn.body_params["code"]
    }

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
