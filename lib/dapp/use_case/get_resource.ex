defmodule Dapp.UseCase.GetResource do
  @moduledoc """
  Example protected resource.
  """
  @behaviour Dapp.UseCase

  def execute(args) do
    if is_nil(args) do
      {:error, "nil args", 400}
    else
      {:ok, "Resource: #{get_name(args)} is authorized"}
    end
  end

  defp get_name(args) do
    unless is_nil(args) || is_nil(args.user) do
      args.user.name
    end
  end
end
