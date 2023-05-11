defmodule Dapp.Repo.Migrations.CreateUserFeatures do
  use Ecto.Migration

  def change do
    create table(:user_features) do
      add :user_id, references(:users, type: :string), size: 21, null: false
      add :feature_id, references(:features), null: false
      timestamps()
    end
    create unique_index(:user_features, [:user_id, :feature_id])
  end
end
