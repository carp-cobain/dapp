defmodule Dapp.Plug.Features do
  @moduledoc """
  Loads feature toggles per request.
  """
  alias Dapp.Repo.FeatureRepo, as: Repo
  import Plug.Conn

  @doc false
  def init(opts), do: opts

  @doc """
  Load and assign feature toggles for a request.
  It is assumed that the number of feature toggles is fairly small.
  """
  def call(conn, _opts) do
    assign(conn, :toggles, toggles(conn) || [])
  end

  # Read toggles for request.
  defp toggles(conn) do
    case Map.get(conn.assigns, :user) do
      nil -> Repo.toggles()
      user -> Repo.toggles() ++ Repo.toggles(user.id)
    end
  end
end
