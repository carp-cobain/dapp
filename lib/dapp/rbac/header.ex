defmodule Dapp.Rbac.Header do
  @moduledoc """
  Extracts blockchain address header.
  """
  import Plug.Conn

  @user_header Application.compile_env(:dapp, :user_header)
  @group_header Application.compile_env(:dapp, :group_header)

  # Get blockchain address header.
  def auth_header(conn) do
    get_header(conn, @group_header) ||
      get_header(conn, @user_header)
  end

  # Get a single header value.
  defp get_header(conn, name) do
    case get_req_header(conn, name) do
      [value] -> value
      _ -> nil
    end
  end
end
