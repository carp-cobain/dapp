defmodule Dapp.Repo.AccessRepo do
  @moduledoc """
  User access repository for the dApp.
  """
  alias Algae.Maybe
  alias Dapp.Repo
  import Ecto.Query

  @doc "Get the access level for a user."
  def access(user_id) do
    (query_role(user_id) || %{})
    |> Map.get(:role)
    |> Maybe.from_nillable()
  end

  # Query for a user's role.
  defp query_role(user_id) do
    unless is_nil(user_id) do
      Repo.one(
        from(r in "roles",
          join: g in "grants",
          on: g.role_id == r.id,
          where: g.user_id == ^user_id,
          select: %{role: r.name}
        )
      )
    end
  end
end
