defmodule Dapp.Plug.Presenter do
  @moduledoc """
  Sends use case results as JSON.
  """
  alias Algae.Either.{Left, Right}
  alias Dapp.Plug.Resp
  require Logger

  # For returning 201
  @post "POST"

  @doc "Send a use case result as a JSON response."
  def reply(%Right{right: {}}, conn) do
    Resp.send_json(conn, %{}, 204)
  end

  # Use case success reply.
  def reply(%Right{right: dto}, conn) do
    if conn.method == @post do
      Resp.send_json(conn, dto, 201)
    else
      Resp.send_json(conn, dto)
    end
  end

  # Use case error reply.
  def reply(%Left{left: {status, error}}, conn) do
    if status == :internal_error do
      Logger.error("Error executing use case: #{inspect(error)}")
    end

    Resp.send_json(conn, %{error: error}, http_status(status))
  end

  @doc "Fail a request with an optional error."
  def send_error(conn, error \\ nil) do
    if is_nil(error) do
      Resp.internal_error(conn)
    else
      Resp.send_json(conn, %{error: error}, 400)
    end
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
