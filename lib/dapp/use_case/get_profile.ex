defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for showing a user profile.
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

  @doc "Get a user profile."
  def execute(ctx, repo) do
    chain do
      args <- Args.from_nillable(ctx)
      user_id <- Args.required(args, :user_id)
      user <- repo.get(user_id)
      Dto.profile(user)
    end
  end
end
