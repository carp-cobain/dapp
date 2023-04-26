defmodule Dapp.Repo do
  @moduledoc """
  Database repository for dApp.
  """
  use Ecto.Repo,
    otp_app: :dapp,
    adapter: Ecto.Adapters.Postgres
end
