defmodule Dapp.Feature.Trial.Expiration do
  @moduledoc """
  Feature macro for trial account expiration.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Feature.ToggleCtx

      # Compile trial ttl from config.
      @trial_ttl_seconds Application.compile_env(:dapp, :trial_ttl_seconds)

      # Account expiration feature toggle.
      @user_expiration ToggleCtx.new(:trial_features, :user_expiration)

      @doc "Check for trial account expiration."
      def feature_expiration(args) do
        case ToggleCtx.enabled?(@user_expiration, args) do
          true -> check_expiration(args.user)
          false -> :does_not_expire
        end
      end

      @doc "Create trial expiration DTO."
      def expiration_dto(status, expires_at),
        do: %{
          trial: %{
            status: status,
            expires_at: expires_at
          }
        }

      # Determine whether a trail period has expired for a user.
      defp check_expiration(user) do
        expires_at = NaiveDateTime.add(user.inserted_at, @trial_ttl_seconds)

        case NaiveDateTime.compare(NaiveDateTime.utc_now(), expires_at) do
          :lt -> {:active, expires_at}
          _ -> {:expired, expires_at}
        end
      end
    end
  end
end
