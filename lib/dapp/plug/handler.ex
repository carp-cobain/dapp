defmodule Dapp.Plug.Handler do
  alias Dapp.Plug.Resp

  # Execute a use case.
  def execute(conn, use_case, params \\ %{}) do
    conn
    |> args(params)
    |> use_case.execute()
    |> reply(conn)
  end

  # Create an args map for use cases.
  defp args(conn, params) do
    Map.merge(%{user: conn.assigns.user, role: conn.assigns.role}, params)
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
