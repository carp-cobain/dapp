defmodule Dapp.Schema.Role do
  @moduledoc """
  Schema data mapper for the roles table.
  """
  import Ecto.Changeset
  use Ecto.Schema

  schema "roles" do
    field(:name, :string)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 255)
    |> unique_constraint(:name)
  end
end
