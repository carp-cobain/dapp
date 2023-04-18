defmodule Dapp.Data.Repo.FeatureRepo do
  @moduledoc """
  Feature toggle queries for dApp.
  """
  alias Dapp.Data.Repo
  alias Dapp.Data.Schema.Feature

  # Load all features with toggles.
  def all() do
    Repo.preload(Repo.all(Feature), [:toggles])
  end
end
