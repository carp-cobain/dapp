defmodule Dapp.Feature.ShowUser do
  @moduledoc """
  Feature toggles for showing user information
  """
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Feature.ToggleCtx

      # Default return value
      @default "user"

      # Global toggle for showing email.
      @show_user_email ToggleCtx.new("global_features", "show_user_email")

      # Show user email if enabled or else a default value.
      def show_user_email(args) do
        case ToggleCtx.enabled?(@show_user_email, args) do
          true -> Map.get(args.user, :email) || @default
          false -> @default
        end
      end

      # Viewer toggle for showing name.
      @show_user_name ToggleCtx.new("viewer_features", "show_user_name")

      # Show user name if enabled or else a default value.
      def show_user_name(args) do
        case ToggleCtx.enabled?(@show_user_name, args) do
          true -> Map.get(args.user, :name) || @default
          false -> @default
        end
      end
    end
  end
end
