defmodule Dapp.Plug.Features do
  @moduledoc """
  Loads feature toggles per request.
  """
  import Plug.Conn
  alias Dapp.Data.Repo.FeatureRepo, as: Repo

  def init(opts), do: opts

  # Load and assign feature toggles if user has been authorized.
  # This strategy assumes the number of feature toggles is fairly small.
  def call(conn, _opts) do
    if Map.has_key?(conn.assigns, :user) do
      # NOTE: Could filter toggles for user here...
      conn |> assign(:toggles, Repo.toggles())
    else
      conn
    end
  end
end
