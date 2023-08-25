defmodule Dapp.Data.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  @behaviour Dapp.Data.Api.UserApi
  use Dapp.Error

  alias Algae.Either.Right

  alias Dapp.Data.Schema.User
  alias Dapp.{Error, Repo}

  # Return error on nil user id.
  def get_user(user_id) when is_nil(user_id) do
    Error.new("user_id cannot be nil") |> invalid_args()
  end

  @doc "Get a user by id and wrap in Either."
  def get_user(user_id) do
    Repo.get(User, user_id)
    |> Repo.preload(:role)
    |> case do
      nil -> Error.new("user not found: #{user_id}") |> not_found()
      user -> Right.new(user)
    end
  end

  # Return error on nil address.
  def get_user_by_address(address) when is_nil(address) do
    Error.new("address cannot be nil") |> invalid_args()
  end

  @doc "Query for the user with the given blockchain address."
  def get_user_by_address(address) do
    Repo.get_by(User, blockchain_address: address)
    |> Repo.preload(:role)
    |> case do
      nil -> Error.new("user not found: #{address}") |> not_found()
      user -> Right.new(user)
    end
  end
end
