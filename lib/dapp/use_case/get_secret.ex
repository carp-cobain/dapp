defmodule Dapp.UseCase.GetSecret do
  @moduledoc """
  Example secret resource (admin only access).
  """
  @behaviour Dapp.UseCase
  use Dapp.Feature.ShowUserEmail

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      error()
    else
      show_user_email(args) |> ok()
    end
  end

  # Error dto
  defp error do
    {:error, "invalid args", 400}
  end

  # Success dto
  defp ok(user) do
    {:ok, "Secret: #{user} is authorized"}
  end
end
