defmodule Dapp.UseCase.ArgsTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.UseCase.Args

  # Return use case context
  setup do
    %{args: %{id: Nanoid.generate(), balance: 100, name: "Jane", email: nil}}
  end

  # Test use case args
  describe "Args" do
    test "should return valid args", ctx do
      assert Right.new(ctx.args) == Args.from_nillable(ctx)
      assert Right.new(ctx.args.id) == Args.get(ctx, :id)
      assert Right.new("jane@email.com") == Args.get(ctx, :email, "jane@email.com")
      assert Right.new({"Jane", 100}) == Args.take(ctx, [:name, :balance])
    end

    test "should return an error on nil context" do
      assert %Left{left: {status, error}} = Args.from_nillable(nil)
      assert error.message == "invalid use case context: nil"
      assert status == :invalid_args
    end

    test "should return an error on nil args in context" do
      assert %Left{left: {status, error}} = Args.from_nillable(%{args: nil})
      assert error.message == "invalid use case args: nil"
      assert status == :invalid_args
    end

    test "should return an error for a missing required arg", ctx do
      assert %Left{left: {status, error}} = Args.get(ctx, :age)
      assert status == :invalid_args
      assert error.message == "use case arg is required"
      assert error.field == :age
    end

    test "should return an error on nil arg value with no default", ctx do
      assert %Left{left: {status, error}} = Args.get(ctx, :email)
      assert status == :invalid_args
      assert error.message == "use case arg is required"
      assert error.field == :email
    end

    test "should fail to take on any missing required arg", ctx do
      assert %Left{left: {status, error}} = Args.take(ctx, [:name, :age])
      assert status == :invalid_args
      assert error.message == "use case arg is required"
      assert error.field == :age
    end
  end
end
