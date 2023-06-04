defmodule Dapp.Rbac.Header do
  @moduledoc """
  Extracts blockchain address header.
  """
  import Plug.Conn

  alias Algae.Maybe
  alias Algae.Maybe.{Just, Nothing}
  use Witchcraft

  # Read header names from config.
  @user_header Application.compile_env(:dapp, :user_header)
  @group_header Application.compile_env(:dapp, :group_header)

  @doc false
  def init(opts), do: opts

  @doc "Assigns blockchain address header if found."
  def call(conn, _opts) do
    case auth_header(conn) do
      %Just{just: address} -> assign(conn, :blockchain_address, address)
      %Nothing{} -> conn
    end
  end

  @doc "Get blockchain address header wrapped in Maybe."
  def auth_header(conn) do
    addr_header(conn)
    |> Maybe.from_nillable()
  end

  # Get group header if provided. Otherwise, get user header.
  defp addr_header(conn) do
    get_header(conn, @group_header) || get_header(conn, @user_header)
  end

  # Get a single header value.
  defp get_header(conn, name) do
    case get_req_header(conn, name) do
      [value] -> value
      _ -> nil
    end
  end
end
