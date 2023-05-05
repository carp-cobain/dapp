defmodule Dapp.Plug.Resp do
  @moduledoc """
  HTTP response helper module.
  """
  import Plug.Conn

  @doc "Not found error helper."
  def not_found(conn) do
    conn
    |> send_json(%{error: "Not found"}, 404)
  end

  @doc "Unauthorized request error helper."
  def unauthorized(conn) do
    conn
    |> send_json(%{error: "Unauthorized"}, 401)
    |> halt
  end

  @doc "Encode data to JSON and send as a HTTP response."
  def send_json(conn, data, status \\ 200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end
