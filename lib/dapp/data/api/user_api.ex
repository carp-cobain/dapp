defmodule Dapp.Data.Api.UserApi do
  @moduledoc """
  Data API for users.
  """
  alias Algae.Either

  @doc "Get a user by ID."
  @callback get_user(String.t()) :: Either.t()

  @doc "Get a user by blockchain address."
  @callback get_user_by_address(String.t()) :: Either.t()
end
