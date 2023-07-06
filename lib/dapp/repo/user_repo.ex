defmodule Dapp.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  alias Algae.Either.{Left, Right}

  alias Dapp.{Error, Repo}
  alias Dapp.Schema.User

  import Ecto.Query

  # Return error on nil user id.
  def get(user_id) when is_nil(user_id) do
    Error.new("user_id cannot be nil")
    |> invalid_args()
  end

  @doc "Get a user by id and wrap in Either."
  def get(user_id) do
    case Repo.get(User, user_id) do
      nil -> Error.new("user not found: #{user_id}") |> not_found()
      user -> Right.new(user)
    end
  end

  # Return error on nil address.
  def get_by_address(address) when is_nil(address) do
    Error.new("address cannot be nil")
    |> invalid_args()
  end

  @doc "Query for the user with the given blockchain address."
  def get_by_address(address) do
    Repo.one(
      from(u in User,
        where: u.blockchain_address == ^address,
        select: u
      )
    )
    |> case do
      nil -> Error.new("user not found: #{address}") |> not_found()
      user -> Right.new(user)
    end
  end

  # Error helper for bad requests
  defp invalid_args(error), do: wrap_error(error, :invalid_args)

  # Error helper for not found
  defp not_found(error), do: wrap_error(error, :not_found)

  # Error helper
  defp wrap_error(error, status), do: {status, error} |> Left.new()
end
