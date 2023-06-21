defmodule Dapp.Repo.RoleRepo do
  @moduledoc """
  Role repository for the dApp.
  """
  alias Dapp.Repo
  alias Dapp.Schema.Role

  @doc "Get all roles."
  def get_roles, do: Repo.all(Role)
end
