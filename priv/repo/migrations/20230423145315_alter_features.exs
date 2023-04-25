defmodule Dapp.Data.Repo.Migrations.AlterFeatures do
  use Ecto.Migration

  def change do
    alter table("features") do
      add :global, :boolean, null: false, default: true
    end
  end
end
