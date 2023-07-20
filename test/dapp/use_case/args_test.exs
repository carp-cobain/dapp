defmodule Dapp.UseCase.ArgsTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.UseCase.Args

  # Return use case context
  setup do
    %{args: %{id: Nanoid.generate(), balance: 100, name: "Jane"}}
  end

  # Test use case args
  describe "Args" do
    test "should return valid args", ctx do
      assert Right.new(ctx.args) == Args.from_nillable(ctx)
      assert Right.new(ctx.args.id) == Args.get(ctx, :id)
      assert Right.new("jane@email.com") == Args.get(ctx, :email, "jane@email.com")
      assert Right.new({"Jane", 100}) == Args.take(ctx, [:name, :balance])
      assert Right.new(%{name: "Jane", balance: 100}) == Args.params(ctx, [:name, :balance])
    end

    test "should return an error on nil context" do
      assert %Left{left: {status, error}} = Args.from_nillable(nil)
      assert status == :invalid_args
      assert error.message == "invalid use case context: nil"
    end

    test "should return an error on nil args in context" do
      assert %Left{left: {status, error}} = Args.from_nillable(%{args: nil})
      assert status == :invalid_args
      assert error.message == "invalid use case args: nil"
    end

    test "should return an error for a missing required arg", ctx do
      assert %Left{left: {status, error}} = Args.get(ctx, :age)
      assert status == :invalid_args
      assert error.field == :age
      assert error.message == "use case arg is required"
    end

    test "should fail to take missing required args", ctx do
      assert %Left{left: {status, error}} = Args.take(ctx, [:name, :age])
      assert status == :invalid_args
      assert error.field == :age
      assert error.message == "use case arg is required"
    end

    test "should return an error when take called with nil keys", ctx do
      assert %Left{left: {status, error}} = Args.take(ctx, nil)
      assert status == :invalid_args
      assert error.message == "nil keys"
    end

    test "should return an error when take called with empty keys", ctx do
      assert %Left{left: {status, error}} = Args.take(ctx, [])
      assert status == :invalid_args
      assert error.message == "empty keys"
    end
  end
end
