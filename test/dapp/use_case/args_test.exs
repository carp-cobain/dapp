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
    test "it should return valid args", ctx do
      assert Right.new(ctx.args) == Args.from_nillable(ctx)
      assert Right.new(ctx.args.id) == Args.required(ctx.args, :id)
      assert Right.new({"Jane", 100}) == Args.take(ctx.args, [:name, :balance])
    end

    test "it should return an error on nil context" do
      assert %Left{left: {error, status}} = Args.from_nillable(nil)
      assert error.message == "invalid use case context: nil"
      assert status == :invalid_args
    end

    test "it should return an error on nil args in context" do
      assert %Left{left: {error, status}} = Args.from_nillable(%{args: nil})
      assert error.message == "invalid use case args: nil"
      assert status == :invalid_args
    end

    test "it should return an error for a missing required arg", ctx do
      assert %Left{left: {error, status}} = Args.required(ctx.args, :age)
      assert error.field == :age
      assert error.message == "use case arg is required"
      assert status == :invalid_args
    end

    test "it should fail to take missing required args", ctx do
      assert %Left{left: {error, status}} = Args.take(ctx.args, [:name, :age])
      assert error.field == :age
      assert error.message == "use case arg is required"
      assert status == :invalid_args
    end
  end
end
