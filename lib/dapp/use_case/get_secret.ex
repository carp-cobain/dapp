defmodule Dapp.UseCase.GetSecret do
  @moduledoc """
  Example secret resource (admin only access).
  """
  @behaviour Dapp.UseCase

  def execute(args) do
    if is_nil(args) do
      {:error, "nil args", 400}
    else
      {:ok, "Secret: #{get_email(args)} is authorized as admin"}
    end
  end

  defp get_email(args) do
    unless is_nil(args) || is_nil(args.user) do
      args.user.email
    end
  end
end
