defmodule Dapp.UseCase.GetSecret do
  @moduledoc """
  Example secret resource (admin only access).
  """
  @behaviour Dapp.UseCase

  # The feature maps to only this use case for this example.
  @feature "get_secret"

  # The toggle for showing a user email.
  @toggle "show_user_email"

  # Execute this use case.
  def execute(args) do
    if is_nil(args) do
      {:error, "nil args", 400}
    else
      {:ok, "Secret: #{get_user(args)} is authorized"}
    end
  end

  # Determine whether to show the user email.
  defp get_user(args) do
    if Dapp.UseCase.ToggleCtx.enabled?(args, @feature, @toggle) do
      args.user.email
    else
      "user"
    end
  end
end
