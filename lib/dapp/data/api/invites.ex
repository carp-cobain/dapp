defmodule Dapp.Data.Api.Invites do
  @moduledoc """
  Database access API for invites.
  """
  alias Algae.Either

  @doc "Create an invite."
  @callback create_invite(map()) :: Either.t()

  @doc "Look up an invite using id and email address."
  @callback get_invite(String.t(), String.t()) :: Either.t()

  @doc "Creates a user from an invite."
  @callback signup(map(), struct()) :: Either.t()
end
