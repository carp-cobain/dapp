defmodule Dapp.UseCase.GetSecret do
  @moduledoc """
  Example secret resource (admin only access).
  """
  @behaviour Dapp.UseCase

  alias Dapp.UseCase.ToggleCtx

  # The toggle for showing user email.
  # The feature applies to only this use case in this example.
  @show_user_email %ToggleCtx{feature: "get_secret", toggle: "show_user_email"}

  # Execute this use case.
  def execute(args) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      get_email(args) |> or_else("user") |> ok()
    end
  end

  # Get the user email if the feature toggle is enabled.
  defp get_email(args) do
    if ToggleCtx.enabled?(@show_user_email, args) do
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
  defp ok(user) do
    {:ok, "Secret: #{user} is authorized"}
  end
end
