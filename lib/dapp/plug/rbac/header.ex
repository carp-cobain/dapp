defmodule Dapp.Plug.Rbac.Header do
  @moduledoc """
  Extracts blockchain address header.
  """
  import Plug.Conn
  alias Dapp.Plug.Resp

  # Read header names from config.
  @user_header Application.compile_env(:dapp, :user_header)
  @group_header Application.compile_env(:dapp, :group_header)

  @doc false
  def init(opts), do: opts

  @doc "Assigns blockchain address header if found."
  def call(conn, _opts) do
    case auth_header(conn) do
      {typ, addr} ->
        conn
        |> assign(:blockchain_address_type, typ)
        |> assign(:blockchain_address, addr)

      _ ->
        Resp.bad_request(conn)
    end
  end

  @doc "Get group header if provided. Otherwise, get user header."
  def auth_header(conn) do
    case get_header(conn, @group_header) do
      nil -> user_header(conn)
      address -> {:group, address}
    end
  end

  # Get the user header value when group not found.
  defp user_header(conn) do
    case get_header(conn, @user_header) do
      nil -> nil
      address -> {:individual, address}
    end
  end

  # Get a single header value.
  defp get_header(conn, name) do
    case get_req_header(conn, name) do
      [value] -> value
      _ -> nil
    end
  end
end
