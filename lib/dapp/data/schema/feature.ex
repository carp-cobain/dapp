defmodule Dapp.Data.Schema.Feature do
  @moduledoc """
  Schema data mapper for the features table.
  """
  use Ecto.Schema
  alias Dapp.Data.Schema.Toggle

  schema "features" do
    field(:name, :string)
    timestamps()
    has_many(:toggles, Toggle)
  end
end
