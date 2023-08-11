defmodule Dapp.Plug.Req.InviteReq do
  @moduledoc """
  Validate invite requests.
  """
  alias Dapp.Error
  alias Ecto.Changeset

  import Ecto.Changeset

  @doc "Validate an invite request."
  def validate(conn) do
    data = %{}
    types = %{email: :string, role_id: :integer}
    keys = Map.keys(types)

    cs =
      {data, types}
      |> Changeset.cast(conn.body_params, keys)
      |> validate_required(keys)
      |> validate_length(:email, min: 3, max: 255)
      |> validate_number(:role_id, greater_than: 0)

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Error.extract(cs)}
    end
  end
end
