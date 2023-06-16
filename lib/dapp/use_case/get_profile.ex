defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for showing a user profile.
  """
  alias Dapp.UseCase.Args
  alias Dapp.UseCase.Dto

  alias Algae.Reader
  import Quark.Partial
  use Witchcraft

  @doc "Wrap use case execution in a reader monad."
  def new(repo) do
    monad %Reader{} do
      ctx <- Reader.ask()
      return(execute(repo, ctx))
    end
  end

  @doc "Get a user profile. Can be called bare, partially applied, and fully curried"
  defpartial execute(repo, ctx) do
    chain do
      args <- Args.from_nillable(ctx)
      user_id <- Args.required(args, :user_id)
      user <- repo.get(user_id)
      Dto.profile(user)
    end
  end
end
