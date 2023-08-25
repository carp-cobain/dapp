defmodule Dapp.Plug.Controller.Signup.SignupRequest do
  @moduledoc """
  Validate signup requests.
  """
  alias Dapp.Error

  alias Ecto.Changeset
  import Ecto.Changeset

  @doc "Gather and validate use case args for user signup."
  def validate(conn) do
    data = %{blockchain_address: conn.assigns.blockchain_address}
    types = %{invite_code: :string, name: :string, email: :string}
    keys = Map.keys(types)

    cs =
      {data, types}
      |> Changeset.cast(conn.body_params, keys)
      |> validate_required(keys)
      |> validate_length(:invite_code, max: 21)
      |> validate_length(:name, min: 1, max: 255)
      |> validate_length(:email, min: 3, max: 255)

    if cs.valid? do
      {:ok, Changeset.apply_changes(cs)}
    else
      {:error, Error.extract(cs)}
    end
  end
end
