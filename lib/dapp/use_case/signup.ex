defmodule Dapp.UseCase.Signup do
  @moduledoc """
  Use case for creating a user profile from an invite.
  """
  use Dapp.UseCase

  alias Dapp.UseCase.Args
  alias Dapp.UseCase.Dto

  @doc "Create a user profile."
  @impl Dapp.UseCase
  def execute(ctx, repo) do
    chain do
      params <- Args.from_nillable(ctx)
      {code, email} <- Args.take(ctx, [:code, :email])
      invite <- repo.invite(code, email)
      user <- repo.signup(params, invite)
      Dto.profile(user)
    end
  end
end
