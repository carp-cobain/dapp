defmodule Dapp.UseCase.GetProfile do
  @moduledoc """
  Use case for getting a user profile.
  """
  alias Dapp.UseCase.{Args, Dto}
  use Dapp.UseCase

  @doc "Get a user profile"
  def execute(ctx, repo: repo, audit: audit) do
    get_user(ctx, repo) >>>
      fn user ->
        audit.log(ctx, audit_name(), "user=#{user.id}")
        Dto.profile(user)
      end
  end

  # Query user
  defp get_user(ctx, repo) do
    Args.get(ctx, :user_id) >>>
      fn user_id -> repo.get(user_id) end
  end
end
