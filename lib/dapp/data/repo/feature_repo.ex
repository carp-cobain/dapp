defmodule Dapp.Data.Repo.FeatureRepo do
  @moduledoc """
  Feature toggle queries for dApp.
  """
  import Ecto.Query
  alias Dapp.Data.Repo

  # Query and flatten all enabled toggles across features.
  def toggles do
    Repo.all(
      from(f in "features",
        join: t in "toggles",
        on: f.id == t.feature_id,
        where: t.enabled == true,
        select: %{
          feature: f.name,
          name: t.name,
          enabled: t.enabled
        }
      )
    )
  end
end
