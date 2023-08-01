defmodule Dapp.UseCase.Role.GetRoles do
  @moduledoc """
  Use case for getting all roles.
  """
  alias Dapp.UseCase.Role.Dto
  use Dapp.UseCase

  @doc "Get all roles."
  def execute(_ctx, repo: repo) do
    roles = repo.get_roles() |> Dto.roles()
    pure(roles)
  end
end
