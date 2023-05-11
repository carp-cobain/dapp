defmodule Dapp.Feature.ToggleCtxTest do
  use ExUnit.Case, async: true

  alias Dapp.Feature.ToggleCtx

  # Test toggle context
  @test_toggle_ctx ToggleCtx.new(:test, :toggle)

  # Test toggle data
  @enabled %{feature: "test", name: "toggle", enabled: true}
  @disabled %{feature: "test", name: "toggle", enabled: false}
  @not_found %{feature: "quality", name: "flipper", enabled: true}
  @missing_enabled %{feature: "test", name: "toggle"}

  # Test context
  setup do
    %{
      enabled: %{toggles: [@enabled]},
      disabled: %{toggles: [@disabled]},
      not_found: %{toggles: [@not_found]},
      empty: %{},
      missing_enabled: %{toggles: [@missing_enabled]},
      nil_toggles: %{toggles: nil}
    }
  end

  # Tests
  describe "ToggleCtx.enabled?/2" do
    test "it returns true with feature toggle enabled", ctx do
      assert ToggleCtx.enabled?(@test_toggle_ctx, ctx.enabled)
    end

    test "it returns false with feature toggle disabled", ctx do
      refute ToggleCtx.enabled?(@test_toggle_ctx, ctx.disabled)
    end

    test "it returns false when feature toggle is not found", ctx do
      refute ToggleCtx.enabled?(@test_toggle_ctx, ctx.not_found)
    end

    test "it defaults to return false with invalid toggle data", ctx do
      refute ToggleCtx.enabled?(@test_toggle_ctx, nil)
      refute ToggleCtx.enabled?(nil, ctx.enabled)
      refute ToggleCtx.enabled?(@test_toggle_ctx, ctx.empty)
      refute ToggleCtx.enabled?(@test_toggle_ctx, ctx.missing_enabled)
      refute ToggleCtx.enabled?(@test_toggle_ctx, ctx.nil_toggles)
    end
  end
end
