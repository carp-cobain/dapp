defmodule Dapp.UseCase.Invite.CreateInvite do
  @moduledoc """
  Use case for creating an invite
  """
  alias Dapp.UseCase.Args
  alias Dapp.UseCase.Invite.Dto
  use Dapp.UseCase

  @doc "Create an invite."
  def execute(ctx, repo: repo, audit: audit) do
    create_invite(ctx, repo) >>>
      fn invite ->
        audit.log(ctx, audit_name(), "invite=#{invite.id}")
        pure(Dto.invite(invite))
      end
  end

  # Generate an invite code and insert.
  defp create_invite(ctx, repo) do
    chain do
      {email, role_id} <- Args.take(ctx, [:email, :role_id])
      let(params = %{email: email, role_id: role_id})
      repo.create_invite(params)
    end
  end
end
