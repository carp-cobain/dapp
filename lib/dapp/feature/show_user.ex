defmodule Dapp.Feature.ShowUser do
  @moduledoc """
  Feature toggles for showing user information
  """
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Feature.ToggleCtx

      # Default return value
      @default "user"

      # Toggle for showing email.
      @show_user_email ToggleCtx.new("admin_features", "show_user_email")

      # Toggle for showing name.
      @show_user_name ToggleCtx.new("global_features", "show_user_name")

      # Toggle for showing name.
      @show_user_timestamps ToggleCtx.new("global_features", "show_user_timestamps")

      # Create a user DTO using feature toggles.
      def show_user(args) do
        %{id: args.user.id, blockchain_address: args.user.blockchain_address}
        |> Map.merge(email_toggle(args))
        |> Map.merge(name_toggle(args))
        |> Map.merge(timestamps_toggle(args))
      end

      # Return user name if toggle is enabled.
      defp name_toggle(args) do
        case ToggleCtx.enabled?(@show_user_name, args) do
          true -> %{name: args.user.name}
          false -> %{}
        end
      end

      # Return user email if toggle is enabled.
      defp email_toggle(args) do
        case ToggleCtx.enabled?(@show_user_email, args) do
          true -> %{email: args.user.email}
          false -> %{}
        end
      end

      # Return user timestamps if toggle is enabled.
      defp timestamps_toggle(args) do
        case ToggleCtx.enabled?(@show_user_timestamps, args) do
          true -> %{inserted_at: args.user.inserted_at, updated_at: args.user.updated_at}
          false -> %{}
        end
      end

      # Show user email or a default value.
      def show_user_email(args) do
        Map.get(email_toggle(args), :email) || @default
      end

      # Show user name or a default value.
      def show_user_name(args) do
        Map.get(name_toggle(args), :name) || @default
      end
    end
  end
end
