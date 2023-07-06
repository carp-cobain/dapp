defmodule Dapp.Repo.Migrations.CreateAudits do
  use Ecto.Migration

  def change do
    create table(:audits) do
      add :who, :string, null: false
      add :what, :string
      add :where, :string, null: false
      add :when, :timestamp
    end
  end
end
