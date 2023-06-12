defmodule Dapp.UseCase.ArgsTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.UseCase.Args

  # Return use case context
  setup do
    %{args: %{user_id: Nanoid.generate(), fst: 100, snd: "asdf"}}
  end

  # Test use case args
  describe "Args" do
    test "it should return valid args", ctx do
      assert Right.new(ctx.args) == Args.from_nillable(ctx)
    end

    test "it should return a required arg", ctx do
      assert Right.new(ctx.args.user_id) == Args.required(ctx.args, :user_id)
    end

    test "it should take required args as a tuple", ctx do
      assert Right.new({100, "asdf"}) == Args.take(ctx.args, [:fst, :snd])
    end

    test "it should return an error on nil context" do
      assert %Left{left: {error, status}} = Args.from_nillable(nil)
      assert error.message == "invalid use case context: nil"
      assert status == 400
    end

    test "it should return an error on nil args in context" do
      assert %Left{left: {error, status}} = Args.from_nillable(%{args: nil})
      assert error.message == "invalid use case args: nil"
      assert status == 400
    end

    test "it should return an error for a missing required arg", ctx do
      assert %Left{left: {error, status}} = Args.required(ctx.args, :name)
      assert error.field == :name
      assert error.detail == "use case arg is required"
      assert status == 400
    end
  end
end
