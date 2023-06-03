defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for showing the authorized user's profile.
  """
  alias Dapp.UseCase.Args

  @behaviour Dapp.UseCase
  @doc "Show the authorized user profile."
  def execute(args) do
    Args.validate(args, &get_profile/1)
  end

  # Get profile DTO.
  defp get_profile(args) do
    args.user
    |> dto()
    |> ok()
  end

  # Create user DTO.
  defp dto(user) do
    %{
      id: user.id,
      blockchain_address: user.blockchain_address,
      name: user.name,
      email: user.email
    }
  end

  # Success result.
  defp ok(dto) do
    {:ok, %{profile: dto}}
  end
end
