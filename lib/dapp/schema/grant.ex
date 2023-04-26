defmodule Dapp.Schema.Grant do
  @moduledoc """
  Schema data mapper for the grants table.
  """
  use Ecto.Schema
  alias Dapp.Schema.{Role, User}

  schema "grants" do
    belongs_to(:user, User, type: Ecto.Nanoid)
    belongs_to(:role, Role)
    timestamps()
  end
end
