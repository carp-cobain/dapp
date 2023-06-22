defmodule Dapp.Plug.Resp do
  @moduledoc """
  HTTP response helper module.
  """
  import Plug.Conn

  alias Dapp.Error

  @doc "Send a generic not found response."
  def not_found(conn) do
    conn
    |> send_json(error("not found"), 404)
  end

  @doc "Send an unauthorized response and halt further request processing."
  def unauthorized(conn) do
    conn
    |> send_json(error("unauthorized"), 401)
    |> halt
  end

  @doc "Encode data to JSON and send as a HTTP response."
  def send_json(conn, data, status \\ 200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end

  # Error helper
  defp error(message), do: %{error: Error.new(message)}
end
