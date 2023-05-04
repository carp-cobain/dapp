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
      {:ok, show_user(args)}
    end
  end
end
