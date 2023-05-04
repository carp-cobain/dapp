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
    combine(ctx, args)
    |> toggle_enabled()
    |> Maybe.from_maybe(else: false)
  end

  # Combine context and args into a nillable tuple.
  defp combine(ctx, args) do
    unless is_nil(ctx) || is_nil(args) do
      {ctx, args}
    end
  end

  # Validate args and determine whether a feature toggle is enabled.
  defp toggle_enabled(tup) do
    Maybe.from_nillable(tup) >>>
      fn {ctx, args} ->
        get_maybe(args, :toggles) >>>
          fn ts -> find_toggle(ts, ctx.feature, ctx.toggle) end >>>
          fn t -> get_maybe(t, :enabled) end
      end
  end

  # Get a field from a map and wrap in a Maybe.
  defp get_maybe(args, field) do
    Map.get(args, field)
    |> Maybe.from_nillable()
  end

  # Find a toggle or return nothing.
  defp find_toggle(ts, feature, name) do
    Enum.find(ts, fn t ->
      Map.get(t, :feature) == feature && Map.get(t, :name) == name
    end)
    |> Maybe.from_nillable()
  end
end
