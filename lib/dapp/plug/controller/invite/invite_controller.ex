defmodule Dapp.Plug.Controller.Invite.InviteController do
  @moduledoc """
  Http controller invite requests.
  """
  use Dapp.Data.Repos
  use Dapp.Plug.Controller

  alias Dapp.Plug.Controller.Invite.InviteRequest
  alias Dapp.UseCase.Invite.CreateInvite

  @doc "Handle create invite requests."
  def create_invite(conn) do
    case InviteRequest.validate(conn) do
      {:ok, args} -> create_invite(conn, args)
      {:error, error} -> send_error(conn, error)
    end
  end

  # Run create invite use case.
  defp create_invite(conn, args) do
    run_use_case(
      conn,
      CreateInvite.new(repo: invite_repo(), audit: audit_repo()),
      args
    )
  end
end
