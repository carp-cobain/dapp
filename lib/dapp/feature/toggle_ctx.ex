defmodule Dapp.Feature.ToggleCtx do
  @moduledoc """
  Feature toggle context.
  """
  use Witchcraft
  import Algae
  alias Algae.Maybe

  @doc "Define toggle context as a product struct."
  defdata do
    feature :: atom()
    toggle :: atom()
  end

  @doc "Determine whether a feature toggle is enabled."
  def enabled?(ctx, args) do
    combine(ctx, args)
    |> toggle_enabled()
    |> Maybe.from_maybe(else: false)
  end

  # Combine toggle context and args into a tuple. If either param is nil,
  # the result is nil.
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
      Map.get(t, :feature) == atos(feature) && Map.get(t, :name) == atos(name)
    end)
    |> Maybe.from_nillable()
  end

  # Shorten atom-to-string call.
  defp atos(atom) do
    Atom.to_string(atom)
  end
end
