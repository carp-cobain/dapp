defmodule GetSecretTest do
  use ExUnit.Case, async: true
  alias Dapp.UseCase.GetSecret

  # User 
  @user %{email: "user@domain.com"}
  @nil_email %{email: nil}

  # Feature toggles
  @toggle %{name: "show_user_email", enabled: true}
  @feature %{name: "get_secret", toggles: [@toggle]}

  # Disabled feature toggles
  @toggle_disabled %{name: "show_user_email", enabled: false}
  @feature_disabled %{name: "get_secret", toggles: [@toggle_disabled]}

  # Test context
  setup do
    %{
      valid_args: %{user: @user},
      enabled_feature: %{user: @user, features: [@feature]},
      disabled_feature: %{user: @user, features: [@feature_disabled]},
      nil_email: %{user: @nil_email, features: [@feature]}
    }
  end

  # Tests
  describe "GetSecret.execute/1" do
    test "it succeeds with valid args", ctx do
      assert GetSecret.execute(ctx.valid_args) == {:ok, "Secret: user is authorized"}
    end

    test "it succeeds with feature toggle enabled", ctx do
      assert GetSecret.execute(ctx.enabled_feature) == {:ok, "Secret: #{@user.email} is authorized"}
    end

    test "it succeeds with feature toggle disabled", ctx do
      assert GetSecret.execute(ctx.disabled_feature) == {:ok, "Secret: user is authorized"}
    end

    test "it falls back to default message with nil email", ctx do
      assert GetSecret.execute(ctx.nil_email) == {:ok, "Secret: user is authorized"}
    end

    test "it fails with nil args" do
      assert GetSecret.execute(nil) == {:error, "invalid args", 400}
    end

    test "it fails with empty args" do
      assert GetSecret.execute(%{}) == {:error, "invalid args", 400}
    end

    test "it fails with nil user" do
      assert GetSecret.execute(%{user: nil}) == {:error, "invalid args", 400}
    end
  end
end
