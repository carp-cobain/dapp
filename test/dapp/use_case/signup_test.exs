defmodule Dapp.UseCase.SignupTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Algae.Reader

  alias Dapp.Mock.UserRepo
  alias Dapp.UseCase.Signup

  # Create and return use case context
  setup do
    addr = "tp#{Nanoid.generate(39)}" |> String.downcase()
    %{args: %{blockchain_address: addr, name: "Jane Doe", email: "jane.doe@email.com"}}
  end

  # Signup success
  test "Signup should create user profile", ctx do
    use_case = Signup.new(UserRepo)
    assert %Right{right: dto} = Reader.run(use_case, ctx)
    assert dto.profile.blockchain_address == ctx.args.blockchain_address
    assert dto.profile.name == ctx.args.name
    assert dto.profile.email == ctx.args.email
    assert %Right{right: found} = UserRepo.get_by_address(ctx.args.blockchain_address)
    assert found.id == dto.profile.id
  end

  # Signup failure
  test "Signup should fail to create user profile with bad args" do
    use_case = Signup.new(UserRepo)
    assert %Left{left: {error, status}} = Reader.run(use_case, %{args: %{}})
    assert Enum.find(error.details, fn e -> e.field == :blockchain_address end)
    assert Enum.find(error.details, fn e -> e.field == :name end)
    assert Enum.find(error.details, fn e -> e.field == :email end)
    assert status == 400
  end
end
