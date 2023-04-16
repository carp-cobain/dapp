defmodule Dapp.Data.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, size: 21, primary_key: true
      add :blockchain_address, :string, null: false
      add :email, :string
      add :name, :string
      timestamps()
    end
    create unique_index(:users, [:blockchain_address])
  end
end
