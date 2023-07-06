defmodule Dapp.UseCase.Signup do
  @moduledoc """
  Use case for creating a user profile from an invite.
  """
  use Dapp.{Auditable, UseCase}
  alias Dapp.UseCase.{Args, Dto}

  @doc "Create a user profile."
  @impl Dapp.UseCase
  def execute(ctx, repo: repo, audit: audit) do
    signup(ctx, repo) >>>
      fn user ->
        audit.log(ctx, audit_name(), "user=#{user.id}")
        Dto.profile(user)
      end
  end

  # Signup chain
  defp signup(ctx, repo) do
    chain do
      args <- Args.from_nillable(ctx)
      {code, email} <- Args.take(ctx, [:code, :email])
      invite <- repo.invite(code, email)
      repo.signup(args, invite)
    end
  end
end
