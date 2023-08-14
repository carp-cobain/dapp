defmodule Dapp.UseCase.Role.GetRoles do
  @moduledoc """
  Use case for getting all roles.
  """
  use Dapp.UseCase
  alias Dapp.UseCase.Dto

  @doc "Get all roles."
  def execute(_ctx, repo: repo) do
    repo.get_roles()
    |> Enum.map(&Dto.from_schema/1)
    |> pure()
  end
end
