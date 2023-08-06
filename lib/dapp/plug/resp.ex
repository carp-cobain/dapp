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
    |> halt
  end

  @doc "Send a bad request and halt further request processing."
  def bad_request(conn) do
    conn
    |> send_json(error("bad request"), 400)
    |> halt
  end

  @doc "Send a 401 and halt further request processing."
  def unauthorized(conn) do
    conn
    |> send_json(error("unauthorized"), 401)
    |> halt
  end

  @doc "Send a 403 and halt further request processing."
  def forbidden(conn) do
    conn
    |> send_json(error("forbidden"), 403)
    |> halt
  end

  @doc "Send a generic internal server error response."
  def internal_error(conn) do
    conn
    |> send_json(error("internal error"), 500)
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
