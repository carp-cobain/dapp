defmodule Dapp.UseCase.ToggleCtx do
  @moduledoc """
  Helper for feature toggles.
  """

  # Determine if a feature toggle is enabled.
  # Again, we assume the total number of features is fairly small.
  def enabled?(args, feature_name, toggle_name) do
    feature = Enum.find(args.features, &(&1.name == feature_name))

    if is_nil(feature) do
      false
    else
      toggle_enabled?(feature.toggles, toggle_name)
    end
  end

  # Determine if a toggle is enabled.
  defp toggle_enabled?(toggles, toggle_name) do
    toggle = Enum.find(toggles, &(&1.name == toggle_name))

    if is_nil(toggle) do
      false
    else
      toggle.enabled
    end
  end
end
