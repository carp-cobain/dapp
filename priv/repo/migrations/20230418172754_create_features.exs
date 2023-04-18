defmodule Dapp.Data.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string, null: false
      timestamps()
    end
    create unique_index(:features, [:name])
  end
end
