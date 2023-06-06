defmodule Dapp.Mock.Db do
  @moduledoc false

  alias Algae.State
  import Algae.State
  use Witchcraft

  # Insert or update a row.
  def upsert(pk, row) do
    monad %State{} do
      modify(&(&1 <> %{pk => row}))
      return(row)
    end
  end

  # Get a row by pk.
  def get(pk) do
    monad %State{} do
      db <- get()
      let(row = Map.get(db, pk))
      return(row)
    end
  end

  # Find a row by column value.
  def find(col, value) do
    monad %State{} do
      rows <- State.get(&rows/1)
      let(row = Enum.find(rows, &(Map.get(&1, col) == value)))
      return(row)
    end
  end

  # Get 'rows' from a db
  defp rows(db), do: Map.values(db)
end
