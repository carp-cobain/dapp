defmodule Dapp.Data.Api.Roles do
  @moduledoc """
  Database access API for roles.
  """
  @callback get_roles :: list(struct())
end
