defmodule Dapp.Plug.Handler do
  @moduledoc """
  HTTP request handler.
  """
  alias Dapp.Plug.Resp

  # Execute a use case.
  def execute(conn, use_case) do
    args(conn)
    |> use_case.execute()
    |> reply(conn)
  end

  # Conn specific args.
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
