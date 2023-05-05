defmodule Dapp.Plug.Handler do
  @moduledoc """
  HTTP request handler.
  """
  alias Dapp.Plug.Resp

  @doc "Execute a use case and send the result DTO as JSON."
  def execute(conn, use_case) do
    args(conn)
    |> use_case.execute()
    |> reply(conn)
  end

  # Build input args for use case execution.
  defp args(conn) do
    %{
      user: conn.assigns.user,
      role: conn.assigns.role,
      toggles: Map.get(conn.assigns, :toggles, []),
      body: conn.body_params,
      query: conn.query_params,
      form: conn.params
    }
  end

  # Use case success (200).
  defp reply({:ok, dto}, conn) do
    Resp.send_json(conn, %{ok: dto})
  end

  # Use case success (201).
  defp reply({:created, dto}, conn) do
    Resp.send_json(conn, %{ok: dto}, 201)
  end

  # Use case failure.
  defp reply({:error, details, status}, conn) do
    Resp.send_json(conn, %{error: details}, status)
  end
end
