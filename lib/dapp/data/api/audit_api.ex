defmodule Dapp.Data.Api.AuditApi do
  @moduledoc """
  Audit logging API.
  """
  @callback log(map(), String.t(), String.t()) :: atom()
end
