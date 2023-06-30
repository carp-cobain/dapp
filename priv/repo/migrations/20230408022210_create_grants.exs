defmodule Dapp.Repo.Migrations.CreateGrants do
  use Ecto.Migration

  def change do
    create table(:grants) do
      add :user_id, references(:users, type: :string), size: 21, null: false
      add :role_id, references(:roles), null: false
      add :invite_id, :string
      timestamps()
    end
    create unique_index(:grants, [:user_id])
    create index(:grants, [:invite_id])
  end
end
