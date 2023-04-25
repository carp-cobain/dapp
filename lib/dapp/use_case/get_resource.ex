defmodule Dapp.UseCase.GetResource do
  @moduledoc """
  Example protected resource.
  """
  @behaviour Dapp.UseCase
  use Dapp.Feature.ShowUserName

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      error()
    else
      show_user_name(args) |> ok()
    end
  end

  # Error dto
  defp error do
    {:error, "invalid args", 400}
  end

  # Success dto
  defp ok(user) do
    {:ok, "Resource: #{user} is authorized"}
  end
end
