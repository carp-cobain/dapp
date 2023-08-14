defmodule Dapp.UseCase.User.GetProfile do
  @moduledoc """
  Use case for getting a user profile.
  """
  alias Dapp.UseCase.{Args, Dto}
  use Dapp.UseCase

  @doc "Get a user profile"
  def execute(ctx, repo: repo, audit: audit) do
    Args.get(ctx, :user_id) >>>
      fn user_id -> repo.get_user(user_id) end >>>
      fn user ->
        :ok = audit.log(ctx, audit_name(), "user=#{user.id}")
        pure(Dto.from_schema(user))
      end
  end
end
