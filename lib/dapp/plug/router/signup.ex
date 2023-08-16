defmodule Dapp.Plug.Router.Signup do
  @moduledoc """
  Maps signup endpoints to use case.
  """
  use Dapp.Data.Repos
  use Plug.Router

  alias Dapp.Plug.{Controller, Resp}
  alias Dapp.Plug.Rbac.Header

  alias Dapp.Plug.Request.SignupRequest
  alias Dapp.UseCase.Invite.Signup

  plug(:match)
  plug(Header)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Create a new user from an invite.
  post "/" do
    case SignupRequest.validate(conn) do
      {:ok, args} -> signup(conn, args)
      {:error, error} -> Resp.send_json(conn, %{error: error}, 400)
    end
  end

  # Execute the Signup use case.
  defp signup(conn, args) do
    Controller.run(
      conn,
      Signup.new(repo: invite_repo(), audit: audit_repo()),
      args
    )
  end

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
