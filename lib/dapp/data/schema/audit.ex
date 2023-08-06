defmodule Dapp.Data.Schema.Audit do
  @moduledoc """
  Schema data mapper for the audits table.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "audits" do
    field(:who, :string)
    field(:what, :string)
    field(:where, :string)
    field(:when, :utc_datetime)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:who, :what, :where, :when])
    |> validate_required([:who, :where, :when])
    |> validate_length(:who, min: 1, max: 255)
    |> validate_length(:where, min: 1, max: 255)
  end
end
