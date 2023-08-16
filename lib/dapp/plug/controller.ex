defmodule Dapp.Plug.Controller do
  @moduledoc """
  Executes use cases with a HTTP request context, and replies with JSON results.
  """
  alias Algae.Reader
  alias Dapp.Plug.Presenter
  require Logger

  @doc "Run a use case and forward results to a presenter."
  def run(conn, use_case, args \\ %{}) do
    http_context(conn, args)
    |> tap(&debug_context/1)
    |> then(fn ctx -> Reader.run(use_case, ctx) end)
    |> Presenter.present(conn)
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      Presenter.fail(conn)
  end

  # Build input context for running a use case
  defp http_context(conn, args) do
    # Add more to context here if required - feature toggles for example.
    Map.merge(conn.assigns, %{args: args, features: []})
  end

  # Debug context for each request.
  defp debug_context(ctx) do
    Logger.debug("Request context = #{inspect(ctx)}")
  end
end
