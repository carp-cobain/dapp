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
        pure(Dto.profile(user))
      end
  end

  # Signup chain
  defp signup(ctx, repo) do
    chain do
      {code, email} <- Args.take(ctx, [:code, :email])
      invite <- repo.invite(code, email)
      params <- Args.params(ctx, [:blockchain_address, :name, :email])
      repo.signup(params, invite)
    end
  end
end
