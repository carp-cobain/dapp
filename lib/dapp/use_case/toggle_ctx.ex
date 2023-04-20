defmodule Dapp.UseCase.ToggleCtx do
  @moduledoc """
  Helper for feature toggles.
  """
  defstruct [:feature, :toggle]

  # Determine if a feature toggle is enabled.
  # Again, we assume the total number of features is fairly small.
  def enabled?(ctx, args) do
    Map.get(args, :toggles, [])
    |> find(ctx.feature, ctx.toggle)
    |> map(fn toggle -> toggle.enabled end)
    |> get_or_else(false)
  end

  # Pass a struct to a predicate when non-nil or else return false
  defp map(struct, f) do
    unless is_nil(struct) do
      f.(struct)
    end
  end

  # Return a value, or a default when value is nil.
  defp get_or_else(value, default) do
    if is_nil(value) do
      default
    else
      value
    end
  end

  # Find a list entry by name.
  defp find(list, feature, name) do
    Enum.find(list, fn toggle ->
      toggle.feature == feature && toggle.name == name
    end)
  end
end
