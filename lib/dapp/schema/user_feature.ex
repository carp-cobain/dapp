defmodule Dapp.Schema.UserFeature do
  @moduledoc """
  Schema data mapper for the user_features table.
  """
  use Ecto.Schema
  alias Dapp.Schema.{Feature, User}

  schema "user_features" do
    belongs_to(:user, User, type: Ecto.Nanoid)
    belongs_to(:feature, Feature)
    timestamps()
  end
end
