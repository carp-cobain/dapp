defmodule Dapp.Auditable do
  @moduledoc """
  Macro for getting the auditable name of a module.
  """
  defmacro __using__(_opts) do
    quote do
      def audit_name do
        "#{__MODULE__}" |> String.split(".") |> List.last()
      end
    end
  end
end
