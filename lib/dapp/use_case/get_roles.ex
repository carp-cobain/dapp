defmodule Dapp.UseCase.GetRoles do
  @moduledoc """
  Use case for getting all roles.
  """
  alias Dapp.UseCase.Dto
  use Dapp.UseCase

  @doc "Get all roles."
  @impl Dapp.UseCase
  def execute(_ctx, repo), do: repo.get_roles() |> Dto.roles()
end
