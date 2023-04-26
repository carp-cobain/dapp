defmodule Dapp.UseCase.GetUsers do
  @moduledoc """
  Return all users in the DB.
  """
  @behaviour Dapp.UseCase

  alias Dapp.Repo.UserRepo
  use Dapp.Feature.ShowUser

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      get_users(args) |> ok()
    end
  end

  # Query and show users
  defp get_users(args) do
    Enum.map(
      UserRepo.all(),
      &show_user(%{user: &1, toggles: args.toggles})
    )
  end

  # Success dto
  defp ok(users), do: {:ok, %{users: users}}
end
