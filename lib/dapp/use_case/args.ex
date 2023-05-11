defmodule Dapp.UseCase.Args do
  @moduledoc "Use case arguments helper functions."

  @doc "Execute a function if use case args are valid."
  def validate(args, exec) do
    if is_nil(args) || is_nil(Map.get(args, :user)) do
      {:error, "invalid args", 400}
    else
      exec.()
    end
  end
end
