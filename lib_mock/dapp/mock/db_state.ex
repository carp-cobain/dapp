defmodule Dapp.Mock.DbState do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      # Per process in-memory db state
      @db_state {__MODULE__, :db}
      defp put_state(db), do: Process.put(@db_state, db)
      defp get_state, do: Process.get(@db_state) || %{}
    end
  end
end
