defmodule Dapp.UseCase.GetUsers do
  @moduledoc """
  Show all users in the DB.
  """
  alias Dapp.Repo.UserRepo
  alias Dapp.UseCase.Args

  @behaviour Dapp.UseCase
  @doc "Query and show all users."
  def execute(args) do
    Args.validate(args, &get_users/1)
  end

  # Get all users
  defp get_users(args) do
    args
    |> show_users()
    |> ok()
  end

  # Query users and map to dto.
  defp show_users(_args) do
    Enum.map(UserRepo.all(), &dto(&1))
  end

  # Create user DTO.
  defp dto(user) do
    %{
      id: user.id,
      blockchain_address: user.blockchain_address,
      name: user.name,
      email: user.email
    }
  end

  # Success DTO helper.
  defp ok(users) do
    {:ok, %{users: users}}
  end
end
