defmodule Dapp.Data.Schema.Role do
  @moduledoc """
  Schema data mapper for the roles table.
  """
  use Ecto.Schema

  schema "roles" do
    field(:name, :string)
  end
end
