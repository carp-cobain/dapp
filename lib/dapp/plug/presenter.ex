defmodule Dapp.Plug.Presenter do
  @moduledoc """
  Handles use case results and replies with JSON.
  """
  alias Algae.Either.{Left, Right}
  alias Dapp.Plug.Resp
  require Logger

  # For returning 201
  @post "POST"

  @doc "Send a use case result as a JSON response."
  def present(%Right{right: dto}, conn) do
    if conn.method == @post do
      Resp.send_json(conn, dto, 201)
    else
      Resp.send_json(conn, dto)
    end
  end

  def present(%Left{left: {status, error}}, conn) do
    if status == :internal_error do
      Logger.error("Error executing use case: #{inspect(error)}")
    end

    Resp.send_json(conn, %{error: error}, http_status(status))
  end

  @doc "Fail with internal error."
  def fail(conn) do
    Resp.internal_error(conn)
  end

  # Convert use case status to http status
  defp http_status(status) do
    case status do
      :invalid_args -> 400
      :not_found -> 404
      :todo -> 501
      :unavailable -> 503
      _ -> 500
    end
  end
end
