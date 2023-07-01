defmodule Dapp.Mock.Db do
  @moduledoc """
  Define mock DB operations with state monads.
  """
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
      rows <- State.get(&Map.values/1)
      let(row = Enum.find(rows, &(Map.get(&1, col) == value)))
      return(row)
    end
  end

  # Delete a row by pk.
  def delete(pk) do
    monad %State{} do
      modify(&Map.delete(&1, pk))
      return(pk)
    end
  end

  # Find all rows with a column value.
  def filter(col, value) do
    monad %State{} do
      rows <- State.get(&Map.values/1)
      let(results = Enum.filter(rows, &(Map.get(&1, col) == value)))
      return(results)
    end
  end
end
