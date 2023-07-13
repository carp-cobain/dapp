defmodule TestUtil do
  @moduledoc false

  alias Dapp.Repo
  alias Dapp.Schema.{Grant, Invite, Role, User}

  @viewer "Viewer"

  # Create a random blockchain address.
  def fake_address do
    "tp#{Nanoid.generate(39)}" |> String.downcase()
  end

  # Create a random invite.
  def setup_invite do
    code = Nanoid.generate()
    email = "#{code}@domain.com"
    role = ensure_role()
    Repo.insert!(%Invite{id: code, email: email, role_id: role.id})
  end

  # Create a random user.
  def setup_user(role_name \\ @viewer) do
    addr = fake_address()
    user = Repo.insert!(%User{blockchain_address: addr})
    Repo.insert!(%Grant{user: user, role: ensure_role(role_name)})
    %{user: user, role_name: role_name}
  end

  # Get or create a role by name.
  def ensure_role(name \\ @viewer) do
    case Repo.get_by(Role, name: name) do
      nil -> Repo.insert!(%Role{name: name})
      role -> role
    end
  end
end
