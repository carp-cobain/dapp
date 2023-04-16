defmodule Dapp.Data.Schema.Grant do
  @moduledoc """
  Schema data mapper for the grants table.
  """
  use Ecto.Schema
  alias Dapp.Data.Schema.{Role, User}

  schema "grants" do
    belongs_to(:user, User, type: Ecto.Nanoid)
    belongs_to(:role, Role)
    timestamps()
  end
end
