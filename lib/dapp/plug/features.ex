defmodule Dapp.Plug.Features do
  @moduledoc """
  Loads feature toggles per request.
  """
  import Plug.Conn
  alias Dapp.Repo.FeatureRepo, as: Repo

  @doc false
  def init(opts), do: opts

  @doc """
  Load and assign feature toggles to a request.
  It is assumed that the number of feature toggles is fairly small.
  """
  def call(conn, _opts) do
    toggles =
      case Map.get(conn.assigns, :user) do
        nil -> Repo.toggles()
        user -> Repo.toggles() ++ Repo.toggles(user.id)
      end

    conn |> assign(:toggles, toggles)
  end
end
