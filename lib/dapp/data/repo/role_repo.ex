defmodule Dapp.Data.Repo.RoleRepo do
  @moduledoc """
  Role repository for the dApp.
  """
  @behaviour Dapp.Data.Api.Roles
  alias Dapp.Data.Schema.Role
  alias Dapp.Repo

  @doc "Get all roles."
  def get_roles, do: Repo.all(Role)
end
