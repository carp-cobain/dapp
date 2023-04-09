defmodule Dapp.Plug.Resp do
  import Plug.Conn

  # Not found error helper.
  def not_found(conn) do
    encode_send_json(conn, 404, %{error: "Not found"})
  end

  # Unauthorized error helper.
  def unauthorized(conn) do
    conn
    |> encode_send_json(401, %{error: "Unauthorized"})
    |> halt
  end

  # Encode data to json and send in a http response.
  def encode_send_json(conn, status, data) do
    send_json(conn, status, Jason.encode!(data))
  end

  # Send a JSON http response.
  def send_json(conn, status, json) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, json)
  end
end
