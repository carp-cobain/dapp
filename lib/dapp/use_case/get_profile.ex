defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for showing the authorized user's profile.
  """
  alias Dapp.UseCase.Args
  use Dapp.Feature.ShowUser
  use Dapp.Feature.Trial.Expiration

  @behaviour Dapp.UseCase
  @doc "Show the authorized user profile."
  def execute(args) do
    Args.validate(args, &get_profile/1)
  end

  # Get profile DTO.
  defp get_profile(args) do
    args
    |> show_user()
    |> check_expires(args)
  end

  # Check for user expiration.
  defp check_expires(user, args) do
    case feature_expiration(args) do
      :does_not_expire -> ok(user)
      {status, expires_at} -> merge(user, status, expires_at)
    end
  end

  # Merge profile data with expiration data.
  defp merge(user, status, expires_at) do
    expiration_dto(status, expires_at)
    |> Map.merge(user)
    |> ok()
  end

  # Success result.
  defp ok(dto) do
    {:ok, %{profile: dto}}
  end
end
