defmodule Dapp.UseCase.Invite.CreateInvite do
  @moduledoc """
  Use case for creating an invite
  """
  alias Dapp.UseCase.{Args, Dto}
  use Dapp.UseCase

  @doc "Create an invite."
  def execute(ctx, repo: repo, audit: audit) do
    create_invite(ctx, repo) >>>
      fn invite ->
        :ok = audit.log(ctx, audit_name(), "invite=#{invite.id}")
        pure(Dto.invite(invite))
      end
  end

  # Crete an invite in the db.
  defp create_invite(ctx, repo) do
    chain do
      {email, role_id} <- Args.take(ctx, [:email, :role_id])
      let(params = %{email: email, role_id: role_id})
      repo.create_invite(params)
    end
  end
end
