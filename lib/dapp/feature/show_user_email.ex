defmodule Dapp.Feature.ShowUserEmail do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Feature.ToggleCtx
      # Default return value
      @default "user"
      # Global toggle for showing email.
      @show_user_email ToggleCtx.new("global_toggles", "show_user_email")
      # Show user name if enabled or else a generic message.
      def show_user_email(args) do
        case ToggleCtx.enabled?(@show_user_email, args) do
          true -> Map.get(args.user, :email) || @default
          false -> @default
        end
      end
    end
  end
end
