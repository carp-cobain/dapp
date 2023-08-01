defmodule Dapp.Schema.User do
  @moduledoc """
  Schema data mapper for the users table.
  """
  import Ecto.Changeset
  use Ecto.Schema

  # Read blockchain network prefix from config.
  @network_prefix Application.compile_env(:dapp, :network_prefix)

  @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
  schema "users" do
    field(:blockchain_address, :string)
    field(:email, :string)
    field(:name, :string)
    timestamps()
  end

  @doc "Validate user changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:blockchain_address, :email, :name])
    |> validate_required([:blockchain_address, :email, :name])
    |> validate_length(:blockchain_address, min: 41, max: 61)
    |> validate_length(:email, min: 3, max: 255)
    |> validate_length(:name, min: 1, max: 255)
    |> unique_constraint(:blockchain_address)
    |> validate_address_prefix()
  end

  # Validate blockchain address prefix.
  def validate_address_prefix(changeset) do
    address = get_field(changeset, :blockchain_address)

    if is_nil(address) || String.starts_with?(address, @network_prefix) do
      changeset
    else
      add_error(changeset, :blockchain_address, "must have prefix: #{@network_prefix}")
    end
  end
end
