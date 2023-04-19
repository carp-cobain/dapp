defmodule Dapp.UseCase.GetSecret do
  @moduledoc """
  Example secret resource (admin only access).
  """
  @behaviour Dapp.UseCase

  alias Dapp.UseCase.ToggleCtx

  # The feature maps to only this use case in this example.
  @feature "get_secret"

  # The toggle for showing a user email.
  @toggle "show_user_email"

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      get_user(args) |> or_else("user") |> complete()
    end
  end

  # Determine whether to show the user email.
  defp get_user(args) do
    if ToggleCtx.enabled?(args, @feature, @toggle) do
      unless is_nil(args.user) do
        Map.get(args.user, :email)
      end
    end
  end

  # Return a default for a nil value.
  defp or_else(value, default) do
    if is_nil(value) do
      default
    else
      value
    end
  end

  # Use case success
  defp complete(user) do
    {:ok, "Secret: #{user} is authorized"}
  end
end
