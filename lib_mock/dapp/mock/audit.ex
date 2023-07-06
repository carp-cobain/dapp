defmodule Dapp.Mock.Audit do
  @moduledoc """
  Mock audit logger for testing.
  """
  require Logger

  # Mock debug logging
  def log(ctx, where, what \\ nil) do
    Logger.debug("ctx = #{inspect(ctx)}, where = #{where}, what = #{what}")
  end
end
