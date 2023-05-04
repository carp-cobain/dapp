defmodule Dapp.UseCase.GetResource do
  @moduledoc """
  Example protected resource.
  """
  @behaviour Dapp.UseCase
  use Dapp.Feature.ShowUser

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      {:ok, "Resource: #{show_user_name(args)} is authorized"}
    end
  end
end
