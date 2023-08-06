defmodule Dapp.Data.Api.Users do
  @moduledoc """
  Database access API for users.
  """
  alias Algae.{Either, Maybe}

  @doc "Get a user by ID."
  @callback get(String.t()) :: Either.t()

  @doc "Get a user by blockchain address."
  @callback get_by_address(String.t()) :: Either.t()

  @doc "Get the role for a user."
  @callback get_role(String.t()) :: Maybe.t()
end
