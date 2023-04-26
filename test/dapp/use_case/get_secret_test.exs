defmodule GetSecretTest do
  use ExUnit.Case, async: true
  alias Dapp.UseCase.GetSecret

  # User
  @user %{email: "user@domain.com"}
  @nil_email %{email: nil}

  # Feature toggles
  @toggle %{feature: "admin_features", name: "show_user_email", enabled: true}
  @toggle_disabled %{feature: "admin_features", name: "show_user_email", enabled: false}

  # Missing feature
  @bad_toggle %{name: "show_user_email", enabled: true}

  # Test context
  setup do
    %{
      # Inputs
      toggle_enabled: %{user: @user, toggles: [@toggle]},
      toggle_disabled: %{user: @user, toggles: [@toggle_disabled]},
      only_user: %{user: @user},
      nil_email: %{user: @nil_email, toggles: [@toggle]},
      bad_toggle: %{user: @user, toggles: [@bad_toggle]},
      # Outputs
      invalid_args: {:error, "invalid args", 400},
      success: fn expect -> {:ok, "Secret: #{expect} is authorized"} end
    }
  end

  # Tests
  describe "GetSecret.execute/1" do
    test "it succeeds with feature toggle enabled", ctx do
      assert GetSecret.execute(ctx.toggle_enabled) == ctx.success.(@user.email)
    end

    test "it succeeds with feature toggle disabled", ctx do
      assert GetSecret.execute(ctx.toggle_disabled) == ctx.success.("-")
    end

    test "it succeeds with only user in args", ctx do
      assert GetSecret.execute(ctx.only_user) == ctx.success.("-")
    end

    test "it falls back to default message with nil email", ctx do
      assert GetSecret.execute(ctx.nil_email) == ctx.success.("-")
    end

    test "it falls back to default message with a bad toggle", ctx do
      assert GetSecret.execute(ctx.bad_toggle) == ctx.success.("-")
    end

    test "it fails with nil args", ctx do
      assert GetSecret.execute(nil) == ctx.invalid_args
    end

    test "it fails with empty args", ctx do
      assert GetSecret.execute(%{}) == ctx.invalid_args
    end

    test "it fails with nil user", ctx do
      assert GetSecret.execute(%{user: nil}) == ctx.invalid_args
    end
  end
end
