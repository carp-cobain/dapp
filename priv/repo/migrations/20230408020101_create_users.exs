defmodule Dapp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, size: 21, primary_key: true
      add :blockchain_address, :string, null: false
      add :name, :string
      add :email, :string
      add :verified_at, :timestamp
      timestamps()
    end
    create unique_index(:users, [:blockchain_address])
  end
end
