defmodule Dapp.UseCase.Signup do
  @moduledoc """
  Use case for creating a user profile from an invite.
  """
  alias Dapp.UseCase.{Args, Dto}
  use Dapp.UseCase

  @doc "Create a user profile."
  def execute(ctx, repo: repo, audit: audit) do
    signup(ctx, repo) >>>
      fn user ->
        audit.log(ctx, audit_name(), "user=#{user.id}")
        return(Dto.profile(user))
      end
  end

  # Signup chain
  defp signup(ctx, repo) do
    chain do
      {code, email} <- Args.take(ctx, [:code, :email])
      invite <- repo.invite(code, email)
      args <- Args.from_nillable(ctx)
      repo.signup(args, invite)
    end
  end
end
