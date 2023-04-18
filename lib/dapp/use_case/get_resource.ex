defmodule Dapp.UseCase.GetResource do
  @moduledoc """
  Example protected resource.
  """
  @behaviour Dapp.UseCase

  # Execute this use case.
  def execute(args) do
    if is_nil(args) do
      {:error, "nil args", 400}
    else
      {:ok, "Resource: user is authorized"}
    end
  end
end
