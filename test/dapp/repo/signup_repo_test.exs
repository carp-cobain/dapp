defmodule Dapp.Repo.SignupRepoTest do
  use ExUnit.Case, async: true

  alias Algae.Either.{Left, Right}
  alias Dapp.Repo
  alias Dapp.Repo.SignupRepo
  alias Dapp.Schema.{Invite, Role}
  alias Ecto.Adapters.SQL.Sandbox

  @signup_role "Viewer"

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)

    # Test context
    code = Nanoid.generate()
    email = "user-#{Nanoid.generate(6)}@domain.com"
    role = setup_role()

    %{
      params: %{
        blockchain_address: "tp#{Nanoid.generate(39)}" |> String.downcase(),
        name: "User #{Nanoid.generate(6)}",
        email: email,
        code: code
      },
      invite: Repo.insert!(%Invite{id: code, email: email, role_id: role.id})
    }
  end

  # Get or insert a role
  defp setup_role do
    case Repo.get_by(Role, name: @signup_role) do
      nil -> Repo.insert!(%Role{name: @signup_role})
      role -> role
    end
  end

  # Test signup repo
  describe "SignupRepo" do
    test "should create a user with a valid invite", ctx do
      assert %Right{right: user} = SignupRepo.signup(ctx.params, ctx.invite)
      assert user.email == ctx.invite.email
    end

    test "should fail to create a user given invalid args", ctx do
      assert %Left{left: {status, _error}} = SignupRepo.signup(%{}, ctx.invite)
      assert status == :invalid_args
    end
  end
end
