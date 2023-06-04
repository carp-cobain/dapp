defmodule Dapp.Plug.Handler do
  @moduledoc """
  HTTP request handler.
  """
  alias Algae.Either.{Left, Right}
  alias Algae.Reader
  alias Dapp.Plug.Resp
  require Logger

  @doc "Run a use case as a reader monad."
  def run(conn, use_case, args \\ %{}) do
    context(conn, args)
    |> tap(&debug_context/1)
    |> then(fn ctx -> Reader.run(use_case, ctx) end)
    |> reply(conn)
  end

  # Build input context for running a use case
  defp context(conn, args) do
    # Add more to context here if required
    %{args: args, assigns: conn.assigns}
  end

  # Debug context for each request.
  defp debug_context(ctx) do
    Logger.debug("ctx = #{inspect(ctx)}")
  end

  # Handle either success case.
  defp reply(%Right{right: {:created, dto}}, conn) do
    Resp.send_json(conn, dto, 201)
  end

  # Handle either success case.
  defp reply(%Right{right: dto}, conn) do
    Resp.send_json(conn, dto)
  end

  # Handle either error case.
  defp reply(%Left{left: {details, status}}, conn) do
    Logger.error("Error executing use case: #{inspect(details)}")
    Resp.send_json(conn, %{error: details}, status)
  end
end
