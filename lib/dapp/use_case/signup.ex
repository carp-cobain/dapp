defmodule Dapp.UseCase.Signup do
  @moduledoc """
  Use case for creating a user profile.
  """
  alias Dapp.UseCase.Args
  alias Dapp.UseCase.Dto

  alias Algae.Reader
  use Witchcraft

  @doc "Wrap use case execution in a reader monad."
  def new(repo) do
    monad %Reader{} do
      ctx <- Reader.ask()
      return(execute(ctx, repo))
    end
  end

  @doc "Create a user profile."
  def execute(ctx, repo) do
    chain do
      args <- Args.from_nillable(ctx)
      user <- repo.signup(args)
      Dto.profile(user)
    end
  end
end
