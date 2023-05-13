defmodule Dapp.Schema.Toggle do
  @moduledoc """
  Schema data mapper for the toggles table.
  """
  use Ecto.Schema

  schema "toggles" do
    field(:name, :string)
    field(:enabled, :boolean, default: false)
    field(:expires_at, :utc_datetime)
    timestamps()
    belongs_to(:feature, Dapp.Schema.Feature)
  end
end
