defmodule Dapp.Data.Repo.AuditRepo do
  @moduledoc """
  Database audit logger for dApp.
  """
  @behaviour Dapp.Data.Api.Audits
  alias Dapp.Data.Schema.Audit
  alias Dapp.Repo
  require Logger

  # Allow disabling audits in config

  @doc "Write an audit log."
  def log(ctx, where, what) do
    unless Application.get_env(:dapp, :audit_disabled, false) do
      %Audit{who: get_who(ctx), where: where, what: what, when: now()}
      |> insert_audit()
    end

    :ok
  end

  # Determine the who field for an audit.
  defp get_who(ctx),
    do: ctx.blockchain_address

  # Current timestamp
  defp now do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end

  # Insert an audit trail in the DB.
  defp insert_audit(audit) do
    Repo.insert!(audit)
  rescue
    e -> Logger.warn(Exception.format(:error, e, __STACKTRACE__))
  end
end
