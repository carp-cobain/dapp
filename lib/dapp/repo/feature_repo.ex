defmodule Dapp.Repo.FeatureRepo do
  @moduledoc """
  Feature toggle queries for dApp.
  """
  import Ecto.Query
  alias Dapp.Repo

  # Query for global feature toggles.
  def toggles do
    Repo.all(
      from(t in "toggles",
        join: f in "features",
        on: f.id == t.feature_id,
        where: f.global == true and t.enabled == true,
        select: %{
          feature: f.name,
          name: t.name,
          enabled: t.enabled
        }
      )
    )
  end

  # Handle nil user_id
  def toggles(user_id) when is_nil(user_id), do: []

  # Query for user feature toggles.
  def toggles(user_id) do
    Repo.all(
      from(t in "toggles",
        join: f in "features",
        on: f.id == t.feature_id,
        join: u in "user_features",
        on: f.id == u.feature_id and u.user_id == ^user_id,
        where: f.global == false and t.enabled == true,
        select: %{
          feature: f.name,
          name: t.name,
          enabled: t.enabled
        }
      )
    )
  end
end
