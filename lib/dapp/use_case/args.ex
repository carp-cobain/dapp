defmodule Dapp.UseCase.Args do
  @moduledoc """
  Use case arguments helper functions.
  """

  @doc "Execute a function if use case args are valid."
  def validate(args, exec) do
    validate(args, [:user], exec)
  end

  @doc "Execute a function if use case args have all required fields."
  def validate(args, fields, exec) do
    if is_nil(args) || missing_fields?(args, fields) do
      {:error, "invalid args", 400}
    else
      exec.(args)
    end
  end

  # Determine whether any of the required fields are missing from args.
  defp missing_fields?(args, fields) do
    Enum.any?(fields, &is_nil(Map.get(args, &1)))
  end
end
