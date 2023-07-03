defmodule Dapp.UseCase.Dto do
  @moduledoc """
  DTO helper functions for use cases.
  """
  alias Dapp.Dto

  alias Algae.Either.Right

  @doc "Create a profile DTO from a user schema struct."
  def profile(user) do
    Dto.from_schema(user)
    |> then(fn dto -> %{profile: dto} end)
    |> Right.new()
  end

  @doc "Create role list DTO from a list of schema structs."
  def roles(roles) do
    Enum.map(roles, &Dto.from_schema/1)
    |> then(fn dto -> %{roles: dto} end)
    |> Right.new()
  end
end
