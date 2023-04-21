defmodule GetSecretTest do
  use ExUnit.Case, async: true
  alias Dapp.UseCase.GetSecret

  # User
  @user %{email: "user@domain.com"}
  @nil_email %{email: nil}

  # Feature toggles
  @toggle %{feature: "get_secret", name: "show_user_email", enabled: true}
  @toggle_disabled %{feature: "get_secret", name: "show_user_email", enabled: false}

  # Test context
  setup do
    %{
      toggle_enabled: %{user: @user, toggles: [@toggle]},
      toggle_disabled: %{user: @user, toggles: [@toggle_disabled]},
      only_user: %{user: @user},
      nil_email: %{user: @nil_email, toggles: [@toggle]}
    }
  end

  # Tests
  describe "GetSecret.execute/1" do
    test "it succeeds with feature toggle enabled", ctx do
      assert execute(ctx.toggle_enabled) == success(@user.email)
    end

    test "it succeeds with feature toggle disabled", ctx do
      assert execute(ctx.toggle_disabled) == success()
    end

    test "it succeeds with only user in args", ctx do
      assert execute(ctx.only_user) == success()
    end

    test "it falls back to default message with nil email", ctx do
      assert execute(ctx.nil_email) == success()
    end

    test "it fails with nil args" do
      assert execute(nil) == invalid_args()
    end

    test "it fails with empty args" do
      assert execute(%{}) == invalid_args()
    end

    test "it fails with nil user" do
      assert execute(%{user: nil}) == invalid_args()
    end
  end

  # Execute the use case under test
  defp execute(args) do
    GetSecret.execute(args)
  end

  # Expected success value
  defp success(expect \\ "user") do
    {:ok, "Secret: #{expect} is authorized"}
  end

  # Invalid args value
  defp invalid_args do
    {:error, "invalid args", 400}
  end
end
