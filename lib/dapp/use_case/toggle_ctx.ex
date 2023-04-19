defmodule Dapp.UseCase.ToggleCtx do
  @moduledoc """
  Helper for feature toggles.
  """

  # Determine if a feature toggle is enabled.
  # Again, we assume the total number of features is fairly small.
  def enabled?(args, feature_name, toggle_name) do
    find(args.features, feature_name)
    |> map(fn feature -> toggle_enabled?(feature.toggles, toggle_name) end)
    |> get_or_else(false)
  end

  # Determine if a toggle is enabled.
  defp toggle_enabled?(toggles, name) do
    find(toggles, name)
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
  defp find(list, name) do
    Enum.find(list, &(&1.name == name))
  end
end
