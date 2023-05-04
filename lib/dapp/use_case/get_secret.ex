defmodule Dapp.UseCase.GetSecret do
  @moduledoc """
  Example secret resource (admin only access).
  """
  @behaviour Dapp.UseCase
  use Dapp.Feature.ShowUser

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      {:ok, "Secret: #{show_user_email(args)} is authorized"}
    end
  end
end
