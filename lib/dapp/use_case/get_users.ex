defmodule Dapp.UseCase.GetUsers do
  @moduledoc "Show all users in the DB."

  @behaviour Dapp.UseCase
  alias Dapp.Repo.UserRepo, as: Users
  use Dapp.Feature.ShowUser

  @doc "Query and show all users."
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      (Map.get(args, :toggles) || [])
      |> get_users()
      |> case do
        users -> {:ok, %{users: users}}
      end
    end
  end

  defp get_users(toggles) do
    Enum.map(
      Users.all(),
      &show_user(%{user: &1, toggles: toggles})
    )
  end
end
