defmodule Dapp.Rbac.Header do
  @moduledoc """
  Extracts blockchain address header.
  """
  import Plug.Conn

  alias Algae.Either.{Left, Right}
  use Witchcraft

  require Logger

  # Read header names from config.
  @user_header Application.compile_env(:dapp, :user_header)
  @group_header Application.compile_env(:dapp, :group_header)

  @doc false
  def init(opts), do: opts

  @doc "Assigns blockchain address header if found."
  def call(conn, _opts) do
    case addr_header(conn) do
      nil -> conn
      address -> assign(conn, :blockchain_address, address)
    end
  end

  @doc "Get blockchain address header wrapped in Either."
  def auth_header(conn) do
    case addr_header(conn) do
      nil -> Left.new("Auth header not found")
      addr -> Right.new(addr)
    end
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
