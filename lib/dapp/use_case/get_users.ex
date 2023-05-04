defmodule Dapp.UseCase.GetUsers do
  @moduledoc """
  Return all users in the DB.
  """
  @behaviour Dapp.UseCase
  use Dapp.Feature.ShowUser
  alias Dapp.Repo.UserRepo, as: Users

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      toggles(args)
      |> get_users()
      |> case do
        users -> {:ok, %{users: users}}
      end
    end
  end

  # Get toggles or empty list.
  defp toggles(args), do: Map.get(args, :toggles) || []

  # Query and show all users.
  defp get_users(toggles) do
    Enum.map(
      Users.all(),
      &show_user(%{user: &1, toggles: toggles})
    )
  end
end
