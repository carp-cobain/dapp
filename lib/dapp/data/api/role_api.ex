defmodule Dapp.Data.Api.RoleApi do
  @moduledoc """
  Data API for roles.
  """
  @callback get_roles :: list(struct())
end
