defmodule Dapp.Plug.Controller do
  @moduledoc """
  Executes use cases with a HTTP request context then forwards results to a presenter.
  """
  alias Algae.Reader
  alias Dapp.Plug.Presenter
  require Logger

  alias __MODULE__

  # Macro hook for controllers.
  defmacro __using__(_opts) do
    quote do
      @doc "Run a use case."
      def run_use_case(conn, use_case, args \\ %{}) do
        Controller.run(conn, use_case, args)
      end

      @doc "Fail a request with optional error."
      def send_error(conn, error \\ nil) do
        Presenter.send_error(conn, error)
      end
    end
  end

  @doc "Run a use case and forward results to a presenter."
  def run(conn, use_case, args \\ %{}) do
    conn
    |> http_context(args)
    |> tap(&debug_context/1)
    |> then(fn ctx -> Reader.run(use_case, ctx) end)
    |> Presenter.reply(conn)
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      Presenter.send_error(conn)
  end

  # Build input context for running a use case
  defp http_context(conn, args) do
    conn.assigns
    |> Map.merge(%{args: args})
    |> Map.merge(%{features: []})
  end

  # Debug context for each request.
  defp debug_context(ctx) do
    Logger.debug("Http request context = #{inspect(ctx)}")
  end
end
