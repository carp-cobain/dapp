defmodule Dapp.UseCase.GetRoles do
  @moduledoc """
  Use case for getting all roles.
  """
  alias Dapp.UseCase.Dto
  use Dapp.UseCase

  @doc "Get all roles."
  def execute(_ctx, repo: repo) do
    repo.get_roles() |> Dto.roles()
  end
end
