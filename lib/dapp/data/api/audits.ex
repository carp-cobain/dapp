defmodule Dapp.Data.Api.Audits do
  @moduledoc """
  Audit logging API.
  """
  @callback log(map(), String.t(), String.t()) :: atom()
end
