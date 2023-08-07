alias Dapp.Data.Domain.Invite
alias Dapp.Data.Domain.Role
alias Dapp.Data.Domain.User

alias Dapp.Data.Schema.Invite, as: InviteSchema
alias Dapp.Data.Schema.Role, as: RoleSchema
alias Dapp.Data.Schema.User, as: UserSchema

defprotocol Dapp.Data.Domain do
  @doc "Create a domain object from a schema struct."
  def from_schema(struct)
end

defimpl Dapp.Data.Domain, for: UserSchema do
  @doc "Create a domain object from a user schema struct."
  def from_schema(user) do
    User.new(user.id, user.blockchain_address, user.name, user.email)
  end
end

defimpl Dapp.Data.Domain, for: RoleSchema do
  @doc "Create a domain object from a role schema struct."
  def from_schema(role) do
    Role.new(role.id, role.name)
  end
end

defimpl Dapp.Data.Domain, for: InviteSchema do
  @doc "Create a domain object from a invite schema struct."
  def from_schema(invite) do
    Invite.new(invite.id, invite.email)
  end
end

# Add more impls for schema types here...
