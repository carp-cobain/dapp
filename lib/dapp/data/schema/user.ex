defmodule Dapp.Data.Schema.User do
  @moduledoc """
  Schema data mapper for the users table.
  """
  use Ecto.Schema

  schema "users" do
    field(:blockchain_address, :string)
    field(:email, :string)
    field(:name, :string)
    timestamps()
  end
end
