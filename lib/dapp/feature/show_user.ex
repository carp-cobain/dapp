defmodule Dapp.Feature.ShowUser do
  @moduledoc """
  Feature macro for showing user information.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Feature.ToggleCtx

      # Default return value.
      @default "user"

      # Toggles for showing users.
      @show_user_email ToggleCtx.new(:admin_features, :show_user_email)
      @show_user_role ToggleCtx.new(:admin_features, :show_user_role)
      @show_user_name ToggleCtx.new(:global_features, :show_user_name)
      @show_user_timestamps ToggleCtx.new(:global_features, :show_user_timestamps)

      @doc "Create a user DTO using enabled feature toggles."
      def show_user(args) do
        %{id: args.user.id, blockchain_address: args.user.blockchain_address}
        |> Map.merge(email_toggle(args))
        |> Map.merge(name_toggle(args))
        |> Map.merge(timestamps_toggle(args))
        |> Map.merge(role_toggle(args))
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

      # Return user role if it exists and the toggle is enabled.
      defp role_toggle(args) do
        case Map.has_key?(args, :role) && ToggleCtx.enabled?(@show_user_role, args) do
          true -> %{role: args.role}
          false -> %{}
        end
      end
    end
  end
end
