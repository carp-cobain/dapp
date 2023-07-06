defmodule Dapp.Audit do
  @moduledoc """
  Database audit logger for dApp.
  """
  alias Dapp.Repo
  alias Dapp.Schema.Audit
  require Logger

  # Allow disabling audits in config
  @audit_disabled Application.compile_env(:dapp, :audit_disabled, false)

  @doc "Write an audit log."
  def log(ctx, where, what \\ nil) do
    unless @audit_disabled do
      %Audit{who: ctx.blockchain_address, where: where, what: what, when: now()}
      |> insert_audit()
    end

    :ok
  end

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
