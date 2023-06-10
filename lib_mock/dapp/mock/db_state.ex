defmodule Dapp.Mock.DbState do
  @moduledoc """
  Allow modules to hold process scoped, in-memory DB state.
  """
  defmacro __using__(_opts) do
    quote do
      @db_state {__MODULE__, :db}
      defp put_state(db), do: Process.put(@db_state, db)
      defp get_state, do: Process.get(@db_state) || %{}
    end
  end
end
