defmodule Dapp.Schema.Feature do
  @moduledoc """
  Schema data mapper for the features table.
  """
  use Ecto.Schema
  alias Dapp.Schema.Toggle

  schema "features" do
    field(:name, :string)
    field(:global, :boolean, default: true)
    timestamps()
    has_many(:toggles, Toggle)
  end
end
