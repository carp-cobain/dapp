defmodule Dapp.UseCase.ToggleCtx do
  @moduledoc """
  Helper for feature toggles.
  """

  # Determine if a feature toggle is enabled.
  # Again, we assume the total number of features is fairly small.
  def enabled?(args, feature_name, toggle_name) do
    find(args.features, feature_name)
    |> and_then(fn feature ->
      toggle_enabled?(feature.toggles, toggle_name)
    end)
  end

  # Determine if a toggle is enabled.
  defp toggle_enabled?(toggles, name) do
    find(toggles, name)
    |> and_then(fn toggle ->
      toggle.enabled
    end)
  end

  # Pass a struct to a predicate when non-nil or else return false
  defp and_then(struct, f) do
    if is_nil(struct) do
      false
    else
      f.(struct)
    end
  end

  # Find a list entry by name.
  defp find(list, name) do
    Enum.find(list, &(&1.name == name))
  end
end
