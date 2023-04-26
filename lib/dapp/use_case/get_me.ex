defmodule Dapp.UseCase.GetMe do
  @moduledoc """
  Return the authorized user.
  """
  @behaviour Dapp.UseCase
  use Dapp.Feature.ShowUser

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      show_user(args) |> ok()
    end
  end

  # Success dto
  defp ok(user), do: {:ok, user}
end
