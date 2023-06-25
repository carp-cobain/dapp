defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for getting a user profile.
  """
  use Dapp.UseCase

  alias Dapp.UseCase.Args
  alias Dapp.UseCase.Dto

  @doc "Get a user profile"
  @impl UseCase
  def execute(ctx, repo) do
    chain do
      user_id <- Args.get(ctx, :user_id)
      user <- repo.get(user_id)
      Dto.profile(user)
    end
  end
end
