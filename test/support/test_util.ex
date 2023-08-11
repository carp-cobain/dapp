defmodule TestUtil do
  @moduledoc false
  alias Algae.Either.{Left, Right}
  alias Dapp.Data.Schema.{Invite, Role, User}
  alias Dapp.Error

  import Hammox

  require Logger

  @user "User"

  # Create a random blockchain address.
  def fake_address,
    do: "tp#{Nanoid.generate(39)}" |> String.downcase()

  # Create a random email address.
  def fake_email,
    do: "#{Nanoid.generate(12)}@domain.com" |> String.downcase()

  # Fake some roles.
  def fake_roles,
    do: [
      %Role{id: 1, name: "Admin"},
      %Role{id: 2, name: "User"}
    ]

  # Setup mock audits API
  def mock_audits,
    do: AuditsMock |> expect(:log, &log/3)

  # Mock debug logging
  defp log(ctx, where, what),
    do: Logger.debug("ctx = #{inspect(ctx)}, where = #{where}, what = #{what}")

  # Define a fake user.
  def fake_user(addr, role_name) do
    %User{
      id: Nanoid.generate(),
      blockchain_address: addr,
      email: fake_email(),
      name: "User #{Nanoid.generate(6)}",
      role: %Role{id: 1, name: role_name}
    }
  end

  # Setup a user with mock data access API.
  def mock_user(role \\ @user) do
    user = fake_user(fake_address(), role)

    UsersMock
    |> expect(:get_user, fn id -> if id == user.id, do: Right.new(user), else: Left.new({:not_found, nil}) end)
    |> expect(:get_user_by_address, fn addr ->
      if addr == user.blockchain_address, do: Right.new(user), else: Left.new({:not_found, nil})
    end)

    user
  end

  # Setup an invite with mock data access API.
  def mock_invite do
    email = fake_email()
    invite = %Invite{id: Nanoid.generate(), email: email, role_id: 1}

    InvitesMock
    |> expect(:create_invite, fn _params -> Right.new(invite) end)
    |> expect(:signup, fn params, invite -> create_user(params, invite) end)
    |> expect(:get_invite, fn id, email ->
      if id == invite.id && email == invite.email, do: Right.new(invite), else: Left.new({:not_found, nil})
    end)

    invite
  end

  # Re-use user changeset for signup mock function.
  defp create_user(params, invite) do
    cs =
      %User{role_id: invite.role_id}
      |> User.changeset(params)

    if cs.valid? do
      Ecto.Changeset.apply_changes(cs)
      |> Right.new()
    else
      {:invalid_args, Error.extract(cs)}
      |> Left.new()
    end
  end

  alias Dapp.Repo

  # Create a role in the test db.
  def ensure_role(name \\ @user) do
    case Repo.get_by(Role, name: name) do
      nil -> Repo.insert!(%Role{name: name})
      role -> role
    end
  end

  # Create a user in the test db.
  def setup_user(role_name \\ @user) do
    addr = fake_address()
    role = ensure_role(role_name)
    user = Repo.insert!(%User{blockchain_address: addr, role_id: role.id})
    %{user: user}
  end

  # Create an invite in the db.
  def setup_invite do
    code = Nanoid.generate()
    email = fake_email()
    role = ensure_role()
    Repo.insert!(%Invite{id: code, email: email, role_id: role.id})
  end
end
