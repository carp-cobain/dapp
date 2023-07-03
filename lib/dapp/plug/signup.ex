defmodule Dapp.Plug.Signup do
  @moduledoc """
  Maps user endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Audit
  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.Header
  alias Dapp.Repo.SignupRepo
  alias Dapp.UseCase.Signup

  plug(:match)
  plug(Header)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Use case options
  @opts [repo: SignupRepo, audit: Audit]

  # Create a new user with viewer grant.
  post "/" do
    Handler.run(
      conn,
      Signup.new(@opts),
      args(conn)
    )
  end

  # Get args from request.
  defp args(conn),
    do: %{
      blockchain_address: conn.assigns.blockchain_address,
      name: conn.body_params["name"],
      email: conn.body_params["email"],
      code: conn.body_params["code"]
    }

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
