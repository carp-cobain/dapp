defmodule Dapp.Feature.ToggleCtx do
  @moduledoc """
  Feature toggle context.
  """
  use Witchcraft
  import Algae
  alias Algae.Maybe

  # Define toggle context as a product struct.
  defdata do
    feature :: String.t()
    toggle :: String.t()
  end

  # Determine if a feature toggle is enabled.
  def enabled?(ctx, args) do
    toggle_enabled(ctx, args)
    |> Maybe.from_maybe(else: false)
  end

  # Determine whether a toggle exists, and is enabled.
  defp toggle_enabled(ctx, args) do
    get_maybe(args, :toggles) >>>
      fn ts -> find_maybe(ts, ctx.feature, ctx.toggle) end >>>
      fn t -> get_maybe(t, :enabled) end
  end

  # Get a field from a map and wrap in a Maybe.
  defp get_maybe(args, field) do
    Map.get(args, field)
    |> Maybe.from_nillable()
  end

  # Find a toggle or return nothing.
  defp find_maybe(ts, feature, name) do
    Enum.find(ts, fn t ->
      Map.get(t, :feature) == feature && Map.get(t, :name) == name
    end)
    |> Maybe.from_nillable()
  end
end
