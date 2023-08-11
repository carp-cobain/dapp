defmodule Dapp.Data.Api.Roles do
  @moduledoc """
  Data API for roles.
  """
  @callback get_roles :: list(struct())
end
