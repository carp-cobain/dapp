defmodule Dapp.Schema.Grant do
  @moduledoc """
  Schema data mapper for the grants table.
  """
  alias Dapp.Schema.{Role, User}
  use Ecto.Schema

  schema "grants" do
    belongs_to(:user, User, type: Ecto.Nanoid)
    belongs_to(:role, Role)
    timestamps()
  end
end
