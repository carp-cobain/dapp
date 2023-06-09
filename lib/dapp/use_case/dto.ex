defmodule Dapp.UseCase.Dto do
  @moduledoc """
  DTO helper functions for use cases.
  """
  alias Algae.Either.Right
  alias Dapp.Dto

  @doc "Create a profile DTO from a user schema struct."
  def profile(user) do
    Dto.from_schema(user)
    |> then(fn dto -> %{profile: dto} end)
    |> Right.new()
  end
end
