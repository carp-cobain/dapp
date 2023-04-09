defmodule Dapp.Plug.Handler do
  import Plug.Conn
  alias Dapp.Plug.Request

  # Execute a use case.
  def execute(conn, use_case) do
    conn
    |> Request.args()
    |> use_case.execute()
    |> respond(conn)
  end

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

  # Use case success.
  defp respond({:ok, msg}, conn) do
    encode_send_json(conn, 200, %{ok: msg})
  end

  # Use case failure.
  defp respond({:error, msg, status}, conn) do
    encode_send_json(conn, status, %{error: msg})
  end

  # Encode data to json and send in a http response.
  defp encode_send_json(conn, status, data) do
    send_json(conn, status, Jason.encode!(data))
  end

  # Send a JSON http response.
  defp send_json(conn, status, json) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, json)
  end
end
