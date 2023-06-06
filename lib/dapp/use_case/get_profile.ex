defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for showing a user profile.
  """
  alias Dapp.Dto.User, as: UserDto
  alias Dapp.UseCase.Args

  alias Algae.Either.Right
  alias Algae.Reader
  use Witchcraft, except: [then: 2]

  @doc "Wrap the GetProfile use case in a reader monad."
  def new(user_repo) do
    monad %Reader{} do
      ctx <- Reader.ask()
      return(execute(ctx, user_repo))
    end
  end

  @doc "Get a user profile."
  def execute(ctx, user_repo) do
    chain do
      args <- Args.from_nillable(ctx)
      user_id <- Args.get(args, :user_id)
      query_user(user_repo, user_id)
    end
  end

  # Query user by ID.
  defp query_user(repo, id) do
    repo.get(id) >>>
      fn user -> user |> dto() |> Right.new() end
  end

  # Create DTO response.
  def dto(user) do
    UserDto.from_schema(user)
    |> then(fn dto -> %{profile: dto} end)
  end
end
