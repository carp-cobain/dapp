defmodule Dapp.Data.Repo.Migrations.CreateToggles do
  use Ecto.Migration

  def change do
    create table(:toggles) do
      add :name, :string, null: false
      add :enabled, :boolean, null: false, default: false
      add :feature_id, references(:features), null: false
      timestamps()
    end
    create unique_index(:toggles, [:name, :feature_id])
  end
end
