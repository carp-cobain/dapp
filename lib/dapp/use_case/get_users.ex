defmodule Dapp.UseCase.GetUsers do
  @moduledoc "Show all users in the DB."
  @behaviour Dapp.UseCase
  use Dapp.Feature.ShowUser
  alias Dapp.Repo.UserRepo
  alias Dapp.UseCase.Args

  @doc "Query and show all users."
  def execute(args), do: Args.validate(args, fn -> get_users(args) end)

  # Get all users
  defp get_users(args) do
    (Map.get(args, :toggles) || [])
    |> show_users()
    |> case do
      users -> {:ok, %{users: users}}
    end
  end

  # Render user data using the authorized user's feature toggles.
  defp show_users(toggles) do
    Enum.map(
      UserRepo.all(),
      &show_user(%{user: &1, toggles: toggles})
    )
  end
end
