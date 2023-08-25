defmodule Dapp.Plug.Controller.User.UserController do
  @moduledoc """
  Http controller for user requests.
  """
  use Dapp.Data.Repos
  use Dapp.Plug.Controller

  alias Dapp.UseCase.User.GetProfile

  @doc "Get user profile."
  def get_profile(conn) do
    run_use_case(
      conn,
      GetProfile.new(repo: user_repo(), audit: audit_repo()),
      %{user_id: conn.assigns.user.id}
    )
  end
end
