defmodule TestUtil do
  @moduledoc false

  alias Algae.Either.{Left, Right}

  alias Dapp.Data.Schema.{Invite, Role, User}
  alias Dapp.Repo

  import Hammox

  require Logger

  @user "User"

  # Setup mock audits API
  def mock_audits, do: AuditsMock |> expect(:log, &log/3)

  # Mock debug logging
  defp log(ctx, where, what) do
    Logger.debug("ctx = #{inspect(ctx)}, where = #{where}, what = #{what}")
  end

  # Create a random blockchain address.
  def fake_address do
    "tp#{Nanoid.generate(39)}" |> String.downcase()
  end

  # Create a random email address.
  def fake_email do
    "#{Nanoid.generate(12)}@email.com" |> String.downcase()
  end

  # Define roles for hammox.
  def fake_roles, do: [%Role{id: 1, name: "Root"}, %Role{id: 2, name: "User"}]

  # Define a fake user for hammox.
  def fake_user(addr \\ fake_address()) do
    %User{
      id: Nanoid.generate(),
      blockchain_address: addr,
      email: fake_email(),
      name: "User #{Nanoid.generate(6)}",
      role_id: 1
    }
  end

  # Setup a user with mock data access API.
  def mock_user(addr \\ fake_address()) do
    user = fake_user(addr)

    UsersMock
    |> expect(:get_user, fn id -> if id == user.id, do: Right.new(user), else: Left.new({:not_found, nil}) end)
    |> expect(:get_user_by_address, fn addr ->
      if addr == user.blockchain_address, do: Right.new(user), else: Left.new({:not_found, nil})
    end)

    %{user: user}
  end

  # Set up an invite with data access mocks.
  def mock_invite(addr) do
    user = fake_user(addr)
    invite = %Invite{id: Nanoid.generate(), email: user.email, role_id: 1}

    InvitesMock
    |> expect(:get_invite, fn _id, _email -> Right.new(invite) end)
    |> expect(:signup, fn _params, _invite -> Right.new(user) end)

    invite
  end

  # Create a random invite in the db.
  def setup_invite do
    code = Nanoid.generate()
    email = fake_email()
    role = ensure_role()
    Repo.insert!(%Invite{id: code, email: email, role_id: role.id})
  end

  # Create a random user in the db.
  def setup_user(role_name \\ @user) do
    addr = fake_address()
    role = ensure_role(role_name)
    user = Repo.insert!(%User{blockchain_address: addr, role_id: role.id})
    %{user: user}
  end

  # Ensure a role with the given name exists in the db.
  def ensure_role(name \\ @user) do
    case Repo.get_by(Role, name: name) do
      nil -> Repo.insert!(%Role{name: name})
      role -> role
    end
  end
end
