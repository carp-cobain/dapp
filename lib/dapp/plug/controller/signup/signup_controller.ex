defmodule Dapp.Plug.Controller.Signup.SignupController do
  @moduledoc """
  Http controller for signup requests.
  """
  use Dapp.Data.Repos
  use Dapp.Plug.Controller

  alias Dapp.Plug.Controller.Signup.SignupRequest
  alias Dapp.UseCase.Invite.Signup

  @doc "Handle signup requests."
  def signup(conn) do
    case SignupRequest.validate(conn) do
      {:ok, args} -> signup(conn, args)
      {:error, error} -> send_error(conn, error)
    end
  end

  # Run signup use case.
  defp signup(conn, args) do
    run_use_case(
      conn,
      Signup.new(repo: invite_repo(), audit: audit_repo()),
      args
    )
  end
end
