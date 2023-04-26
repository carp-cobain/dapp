defmodule Dapp.Feature.ShowUser do
  @moduledoc """
  Feature toggles for showing user information
  """
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Feature.ToggleCtx

      # Default return value
      @default "-"

      # Toggle for showing email.
      @show_user_email ToggleCtx.new("admin_features", "show_user_email")

      # Toggle for showing name.
      @show_user_name ToggleCtx.new("global_features", "show_user_name")

      # Show user dto
      def show_user(args) do
        %{id: args.user.id, blockchain_address: args.user.blockchain_address}
        |> Map.merge(email_toggle(args))
        |> Map.merge(name_toggle(args))
      end

      # Return user name if toggle is enabled.
      defp name_toggle(args) do
        if ToggleCtx.enabled?(@show_user_name, args) do
          %{name: args.user.name}
        else
          %{}
        end
      end

      # Return user email if toggle is enabled.
      defp email_toggle(args) do
        if ToggleCtx.enabled?(@show_user_email, args) do
          %{email: args.user.email}
        else
          %{}
        end
      end

      # Show user email if enabled or else a default value.
      def show_user_email(args) do
        @show_user_email
        |> show_field(args, :email)
      end

      # Show user name if enabled or else a default value.
      def show_user_name(args) do
        @show_user_name
        |> show_field(args, :name)
      end

      # Show user field when a feature toggle is enabled.
      defp show_field(ctx, args, field) do
        case ToggleCtx.enabled?(ctx, args) do
          true -> Map.get(args.user, field) || @default
          false -> @default
        end
      end
    end
  end
end
