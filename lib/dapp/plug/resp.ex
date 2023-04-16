defmodule Dapp.Plug.Resp do
  @moduledoc """
  HTTP response helpers.
  """
  import Plug.Conn

  # Not found error helper.
  def not_found(conn) do
    conn
    |> send_json(%{error: "Not found"}, 404)
  end

  # Unauthorized error helper.
  def unauthorized(conn) do
    conn
    |> send_json(%{error: "Unauthorized"}, 401)
    |> halt
  end

  # Encode data to json and send in a http response.
  def send_json(conn, data, status \\ 200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end
