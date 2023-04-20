defmodule Dapp.Plug.Handler do
  @moduledoc """
  HTTP request handler.
  """
  alias Dapp.Plug.Resp

  # Execute a use case.
  def execute(conn, use_case, params \\ %{}) do
    conn
    |> args(params)
    |> use_case.execute()
    |> reply(conn)
  end

  # Args for use case execution.
  defp args(conn, params) do
    conn
    |> args()
    |> Map.merge(params)
  end

  # Conn specific args.
  defp args(conn) do
    %{
      user: conn.assigns.user,
      role: conn.assigns.role,
      toggles: conn.assigns.toggles,
      body: conn.body_params,
      query: conn.query_params,
      form: conn.params
    }
  end

  # Use case success.
  defp reply({:ok, dto}, conn) do
    Resp.send_json(conn, %{ok: dto})
  end

  # Use case failure.
  defp reply({:error, details, status}, conn) do
    Resp.send_json(conn, %{error: details}, status)
  end
end
