defmodule Dapp.Plug.Request do
  #
  # Create an args map for use cases.
  #
  def args(conn) do
    %{
      user: Map.get(conn.assigns, :user),
      role: Map.get(conn.assigns, :role),
      params: conn.params,
      body: conn.body_params,
      query: conn.query_params
    }
  end

  #
  # Create an args map with extra params for use cases.
  #
  def args(conn, extra) do
    args = args(conn)
    if is_nil(extra), do: args, else: Map.merge(args, extra)
  end
end
