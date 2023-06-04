defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for showing a user profile.
  """
  alias Dapp.Dto.User, as: UserDto
  alias Dapp.UseCase.Args

  alias Algae.Either.Right
  alias Algae.Reader
  use Witchcraft, except: [then: 2]

  @doc "Create a GetProfile reader monad"
  def new(user_repo) do
    monad %Reader{} do
      ctx <- Reader.ask()
      return(get_profile(ctx, user_repo))
    end
  end

  # Get a user profile.
  defp get_profile(ctx, repo) do
    chain do
      args <- Args.from_nillable(ctx)
      user_id <- Args.get(args, :user_id)
      query_user(repo, user_id)
    end
  end

  # Query user by ID.
  defp query_user(repo, id) do
    repo.get(id) >>>
      fn user -> user |> dto() |> Right.new() end
  end

  # Create DTO response.
  def dto(u) do
    UserDto.new(u.id, u.blockchain_address, u.name, u.email)
    |> then(fn dto -> %{profile: dto} end)
  end
end
