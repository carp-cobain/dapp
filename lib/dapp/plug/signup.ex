defmodule Dapp.Plug.Signup do
  @moduledoc """
  Maps user endpoints to use cases.
  """
  use Plug.Router

  alias Dapp.Plug.{Handler, Resp}
  alias Dapp.Rbac.Header
  alias Dapp.Repo.UserRepo
  alias Dapp.UseCase.Signup

  plug(:match)
  plug(Header)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Create a new user with viewer grant.
  post "/" do
    signup = Handler.by_lazy(conn, Signup.apply(UserRepo))
    signup.(args(conn))
  end

  # Get args from request.
  defp args(conn),
    do: %{
      blockchain_address: conn.assigns.blockchain_address,
      name: conn.body_params["name"],
      email: conn.body_params["email"]
    }

  # Catch-all responds with a 404.
  match _ do
    Resp.not_found(conn)
  end
end
