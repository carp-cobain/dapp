defmodule Dapp.Repo.Migrations.CreateAudits do
  use Ecto.Migration

  def change do
    create table(:audits, primary_key: false) do
      add :id, :string, size: 21, primary_key: true
      add :who, :string, null: false
      add :what, :string
      add :where, :string, null: false
      add :when, :timestamp
    end
  end
end
