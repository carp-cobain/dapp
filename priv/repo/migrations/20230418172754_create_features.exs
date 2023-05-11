defmodule Dapp.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string, null: false
      add :global, :boolean, null: false, default: true
      timestamps()
    end
    create unique_index(:features, [:name])
  end
end
