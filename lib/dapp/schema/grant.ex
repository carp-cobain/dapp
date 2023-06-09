defmodule Dapp.Schema.Grant do
  @moduledoc """
  Schema data mapper for the grants table.
  """
  alias Dapp.Schema.{Role, User}
  import Ecto.Changeset
  use Ecto.Schema

  schema "grants" do
    belongs_to(:user, User, type: Ecto.Nanoid)
    belongs_to(:role, Role)
    timestamps()
  end

  @doc "Validate grant changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:role_id)
  end
end
