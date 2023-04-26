defmodule Dapp.UseCase.GetResourceTest do
  use ExUnit.Case, async: true
  alias Dapp.UseCase.GetResource

  # User
  @user %{name: "jondoe"}
  @nil_name %{name: nil}

  # Feature toggles
  @toggle %{feature: "viewer_features", name: "show_user_name", enabled: true}
  @toggle_disabled %{feature: "viewer_features", name: "show_user_name", enabled: false}

  # Missing feature
  @bad_toggle %{name: "show_user_name", enabled: true}

  # Test context
  setup do
    %{
      # Inputs
      toggle_enabled: %{user: @user, toggles: [@toggle]},
      toggle_disabled: %{user: @user, toggles: [@toggle_disabled]},
      only_user: %{user: @user},
      nil_name: %{user: @nil_name, toggles: [@toggle]},
      bad_toggle: %{user: @user, toggles: [@bad_toggle]},
      # Outputs
      invalid_args: {:error, "invalid args", 400},
      success: fn expect -> {:ok, "Resource: #{expect} is authorized"} end
    }
  end

  # Tests
  describe "GetResource.execute/1" do
    test "it succeeds with feature toggle enabled", ctx do
      assert GetResource.execute(ctx.toggle_enabled) == ctx.success.(@user.name)
    end

    test "it succeeds with feature toggle disabled", ctx do
      assert GetResource.execute(ctx.toggle_disabled) == ctx.success.("user")
    end

    test "it succeeds with only user in args", ctx do
      assert GetResource.execute(ctx.only_user) == ctx.success.("user")
    end

    test "it falls back to default message with nil name", ctx do
      assert GetResource.execute(ctx.nil_name) == ctx.success.("user")
    end

    test "it falls back to default message with a bad toggle", ctx do
      assert GetResource.execute(ctx.bad_toggle) == ctx.success.("user")
    end

    test "it fails with nil args", ctx do
      assert GetResource.execute(nil) == ctx.invalid_args
    end

    test "it fails with empty args", ctx do
      assert GetResource.execute(%{}) == ctx.invalid_args
    end

    test "it fails with nil user", ctx do
      assert GetResource.execute(%{user: nil}) == ctx.invalid_args
    end
  end
end
