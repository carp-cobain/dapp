defmodule Dapp.UseCase.Signup do
  @moduledoc """
  Use case for creating a user profile.
  """
  use Dapp.UseCase

  alias Dapp.UseCase.Args
  alias Dapp.UseCase.Dto

  @doc "Create a user profile."
  @impl UseCase
  def execute(ctx, repo) do
    chain do
      args <- Args.from_nillable(ctx)
      user <- repo.signup(args)
      Dto.profile(user)
    end
  end
end
