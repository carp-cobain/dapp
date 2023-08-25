defmodule Dapp.Data.Repos do
  @moduledoc """
  Macro for loading repos (allows data api mocks).
  """
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Data.Api.{AuditApi, InviteApi, RoleApi, UserApi}
      alias Dapp.Data.Repo.{AuditRepo, InviteRepo, RoleRepo, UserRepo}

      # Get configured audit repo.
      @spec audit_repo :: AuditApi
      defp audit_repo,
        do: Application.get_env(:dapp, :audit_repo, AuditRepo)

      # Get configured invite repo.
      @spec invite_repo :: InviteApi
      defp invite_repo,
        do: Application.get_env(:dapp, :invite_repo, InviteRepo)

      # Get configured role repo.
      @spec role_repo :: RoleApi
      defp role_repo,
        do: Application.get_env(:dapp, :role_repo, RoleRepo)

      # Get configured user repo.
      @spec user_repo :: UserApi
      defp user_repo,
        do: Application.get_env(:dapp, :user_repo, UserRepo)
    end
  end
end
