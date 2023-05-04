defmodule Dapp.Schema.Toggle do
  @moduledoc """
  Schema data mapper for the toggles table.
  """
  use Ecto.Schema
  alias Dapp.Schema.Feature

  schema "toggles" do
    field(:name, :string)
    field(:enabled, :boolean, default: false)
    timestamps()
    belongs_to(:feature, Feature)
  end
end