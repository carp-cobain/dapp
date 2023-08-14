defmodule Dapp.UseCase.Invite.CreateInvite do
  @moduledoc """
  Use case for creating an invite
  """
  alias Dapp.UseCase.{Args, Dto}
  use Dapp.UseCase

  @doc "Create an invite."
  def execute(ctx, repo: repo, audit: audit) do
    Args.params(ctx, [:email, :role_id]) >>>
      fn params -> repo.create_invite(params) end >>>
      fn invite ->
        :ok = audit.log(ctx, audit_name(), "invite=#{invite.id}")
        pure(Dto.from_schema(invite))
      end
  end
end
