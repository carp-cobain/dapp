defmodule Dapp.Feature.ShowUserName do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Feature.ToggleCtx
      # Default return value
      @default "user"
      # User toggle for showing name.
      @show_user_name ToggleCtx.new("viewer_features", "show_user_name")
      # Show user name if enabled or else a generic message.
      def show_user_name(args) do
        case ToggleCtx.enabled?(@show_user_name, args) do
          true -> Map.get(args.user, :name) || @default
          false -> @default
        end
      end
    end
  end
end
