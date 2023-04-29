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
        Map.get(email_toggle(args), :email) || @default
      end

      # Show user name if enabled or else a default value.
      def show_user_name(args) do
        Map.get(name_toggle(args), :name) || @default
      end
    end
  end
end
