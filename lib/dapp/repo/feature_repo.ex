defmodule Dapp.Repo.FeatureRepo do
  @moduledoc """
  Feature toggle repository for the dApp.
  """
  alias Dapp.Repo
  import Ecto.Query

  @doc """
  Get all enabled global feature toggles.
  """
  def toggles do
    Repo.all(
      from(t in "toggles",
        join: f in "features",
        on: f.id == t.feature_id,
        where: f.global == true and t.enabled == true and t.expires_at > ^now(),
        select: %{
          feature: f.name,
          name: t.name,
          enabled: t.enabled
        }
      )
    )
  end

  @doc """
  Get all enabled feature toggles for a user. If the user_id is nil,
  return an empty list.
  """
  def toggles(user_id) when is_nil(user_id), do: []

  def toggles(user_id) do
    Repo.all(
      from(t in "toggles",
        join: f in "features",
        on: f.id == t.feature_id,
        join: u in "user_features",
        on: f.id == u.feature_id and u.user_id == ^user_id,
        where: f.global == false and t.enabled == true and t.expires_at > ^now(),
        select: %{
          feature: f.name,
          name: t.name,
          enabled: t.enabled
        }
      )
    )
  end

  # Current time UTC
  defp now do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end
end
