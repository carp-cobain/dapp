defmodule Dapp.Plug.Handler do
  @moduledoc """
  Executes use cases with a HTTP request context, and replies with JSON results.
  """
  alias Algae.Either.{Left, Right}
  alias Algae.Reader
  alias Dapp.Plug.Resp
  require Logger

  # For returning 201
  @post "POST"

  @doc "Run a use case as a reader monad."
  def run(conn, use_case, args \\ %{}) do
    context(conn, args)
    |> tap(&debug_context/1)
    |> then(fn ctx -> Reader.run(use_case, ctx) end)
    |> reply(conn)
  end

  # Build input context for running a use case
  defp context(conn, args) do
    # Add more to context here if required - feature flags for example.
    Map.merge(conn.assigns, %{args: args, toggles: []})
  end

  # Debug context for each request.
  defp debug_context(ctx) do
    Logger.debug("Request context = #{inspect(ctx)}")
  end

  # Handle either success case.
  defp reply(%Right{right: dto}, conn) do
    if conn.method == @post do
      Resp.send_json(conn, dto, 201)
    else
      Resp.send_json(conn, dto)
    end
  end

  # Handle either error case.
  defp reply(%Left{left: {status, error}}, conn) do
    if status == :internal_error do
      Logger.error("Error executing use case: #{inspect(error)}")
    end

    Resp.send_json(conn, %{error: error}, http_status(status))
  end

  # Convert use case status to http status
  defp http_status(status) do
    case status do
      :invalid_args -> 400
      :not_found -> 404
      _ -> 500
    end
  end
end
