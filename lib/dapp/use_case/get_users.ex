defmodule Dapp.UseCase.GetUsers do
  @moduledoc """
  Show all users in the DB.
  """
  alias Dapp.Repo.UserRepo
  alias Dapp.UseCase.Args
  use Dapp.Feature.ShowUser

  @behaviour Dapp.UseCase
  @doc "Query and show all users."
  def execute(args) do
    Args.validate(args, &get_users/1)
  end

  # Get all users
  defp get_users(args) do
    args.toggles
    |> show_users()
    |> ok()
  end

  # Render user data using the authorized user's feature toggles.
  defp show_users(toggles) do
    Enum.map(
      UserRepo.all(),
      &show_user(%{user: &1, toggles: toggles})
    )
  end

  # Success DTO helper.
  defp ok(users) do
    {:ok, %{users: users}}
  end
end
