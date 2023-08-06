defmodule Dapp.Data.Schema.Invite do
  @moduledoc """
  Schema data mapper for the invites table.
  """
  alias Dapp.Data.Schema.Role
  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
  schema "invites" do
    field(:email, :string)
    field(:consumed_at, :naive_datetime)
    belongs_to(:role, Role)
    timestamps()
  end

  @doc "Validate invite changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:email, :role_id, :consumed_at])
    |> validate_required([:email, :role_id])
    |> validate_length(:email, min: 3, max: 255)
    |> foreign_key_constraint(:role_id)
    |> unique_constraint(:email)
  end
end
