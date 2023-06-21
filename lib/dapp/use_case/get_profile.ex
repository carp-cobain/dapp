defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for getting a user profile.
  """
  use Dapp.UseCase

  alias Dapp.UseCase.Args
  alias Dapp.UseCase.Dto

  @doc "Get a user profile"
  @impl Dapp.UseCase
  def execute(ctx, repo) do
    chain do
      args <- Args.from_nillable(ctx)
      user_id <- Args.required(args, :user_id)
      user <- repo.get(user_id)
      Dto.profile(user)
    end
  end
end
